--[[
autocrop-memory.lua - persist manual autocrop (SHIFT+C) per file.

Companion to autocrop.lua (leave that file untouched).
autocrop.lua sets `file-local-options/video-crop`, which mpv clears on
every playlist-next/prev. mpv watch-later only restores it on quit +
reopen, so navigating a playlist loses the crop.

This script remembers the crop per path/URL in ~~ /crop-memory.json:
- SHIFT+C once -> saved, auto-reapplied on file-loaded (playlist jumps
  and future restarts) without pressing SHIFT+C again.
- SHIFT+C again (clear crop) -> entry deleted, bars stay next time.

Options (script-opts/autocrop-memory.conf):
  memory_path=~~/crop-memory.json
  osd_messages=yes
  restore_delay=0.02
--]]
local options = {
    memory_path = "~~/crop-memory.json",
    osd_messages = true,
    restore_delay = 0.02,
}
require("mp.options").read_options(options, "autocrop-memory")

local utils = require("mp.utils")
local msg = require("mp.msg")

local mem_path = mp.command_native({ "expand-path", options.memory_path })
local db = {}
local current_key = nil
local restoring = false
local save_timer = nil
-- Guard against file-switch transients: mpv resets video-crop to "" between
-- files, which must not delete the outgoing file's saved entry.
local ignore_clear_until = 0

local function load_db()
    local info = utils.file_info(mem_path)
    if not info then
        return
    end
    local f = io.open(mem_path, "r")
    if not f then
        msg.warn("autocrop-memory: cannot read " .. mem_path)
        return
    end
    local content = f:read("*a")
    f:close()
    if not content or content == "" then
        return
    end
    local parsed = utils.parse_json(content)
    if type(parsed) == "table" then
        db = parsed
    else
        msg.warn("autocrop-memory: corrupt JSON, starting empty")
    end
end

local function write_db_now()
    local f, err = io.open(mem_path, "w")
    if not f then
        msg.error("autocrop-memory: cannot write " .. mem_path .. ": " .. tostring(err))
        return
    end
    if next(db) == nil then
        f:write("{}")
    else
        f:write(utils.format_json(db) or "{}")
    end
    f:close()
end

local function schedule_save()
    -- Coalesce rapid observer callbacks into one write.
    if save_timer then
        save_timer:kill()
    end
    save_timer = mp.add_timeout(0.3, function()
        save_timer = nil
        write_db_now()
    end)
end

local function get_key()
    local path = mp.get_property("path")
    if not path or path == "" then
        return nil
    end
    if path:find("://", 1, true) then
        return path
    end
    local dir = mp.get_property("working-directory", "")
    return utils.join_path(dir, path)
end

local function normalize_path(p)
    if not p or p == "" then
        return nil
    end
    if p:find("://", 1, true) then
        return p
    end
    return utils.join_path(mp.get_property("working-directory", ""), p)
end

local function on_path(_, new_path)
    -- `path` observer carries the incoming value directly, so unlike
    -- start-file/file-loaded handlers it cannot read a stale file.
    local key = normalize_path(new_path)
    if not key then
        return
    end
    current_key = key
    ignore_clear_until = mp.get_time() + 1.0
    local saved = db[key]
    if not saved or saved == "" then
        return
    end
    if mp.get_property("video-crop", "") == saved then
        return
    end
    restoring = true
    mp.set_property("file-local-options/video-crop", saved)
    restoring = false
    msg.info("autocrop-memory: restored crop " .. saved .. " (path)")
    if options.osd_messages then
        mp.osd_message("Crop restored: " .. saved, 1.5)
    end
end

local function on_file_loaded()
    current_key = get_key()
    -- Ignore "" resets while the new file settles; a real user untoggle
    -- happens well after load.
    ignore_clear_until = mp.get_time() + 1.0
    if not current_key then
        return
    end
    local saved = db[current_key]
    if not saved or saved == "" then
        -- No memory for this file but a crop is showing: leftover carried
        -- over from the previous file (reset-on-next-file=pause). Clear it
        -- so uncropped files never inherit bars removal.
        if mp.get_property("video-crop", "") ~= "" then
            restoring = true
            mp.set_property("file-local-options/video-crop", "")
            restoring = false
        end
        return
    end
    -- Synchronous apply: no artificial delay, so at most the very first
    -- frame can show bars.
    if mp.get_property("video-crop", "") == saved then
        return
    end
    restoring = true
    mp.set_property("file-local-options/video-crop", saved)
    restoring = false
    msg.info("autocrop-memory: restored crop " .. saved .. " (file-loaded)")
    if options.osd_messages then
        mp.osd_message("Crop restored: " .. saved, 1.5)
    end
    -- Fallback re-assert in case something (e.g. autocrop cleanup running
    -- after us on the same event) resets it right after.
    if options.restore_delay and options.restore_delay > 0 then
        local key_at_schedule = current_key
        mp.add_timeout(options.restore_delay, function()
            if get_key() ~= key_at_schedule then
                return
            end
            if mp.get_property("video-crop", "") == saved then
                return
            end
            restoring = true
            mp.set_property("file-local-options/video-crop", saved)
            restoring = false
        end)
    end
end

local function on_crop_change(_, val)
    if restoring then
        return
    end
    if not current_key then
        return
    end
    if not val or val == "" then
        -- File switch resets crop to "" between end-file and file-loaded.
        -- Only a stable same-file "" is a real user untoggle.
        if mp.get_time() < ignore_clear_until then
            return
        end
        if get_key() ~= current_key then
            return
        end
        if db[current_key] then
            db[current_key] = nil
            msg.info("autocrop-memory: cleared crop for " .. current_key)
            schedule_save()
        end
        return
    end
    -- Save against the live path so a lagging current_key can never file
    -- one video's crop under another video.
    local live = get_key() or current_key
    if not live then
        return
    end
    current_key = live
    if db[live] == val then
        return
    end
    -- Right after a switch mpv can briefly carry the previous file's crop
    -- into the new file before file-loaded settles. Never memorize that
    -- transient; real crops are set by the user well after load (plus ~1s
    -- of cropdetect), and our own restores already match the DB.
    if mp.get_time() < ignore_clear_until then
        return
    end
    db[live] = val
    msg.info("autocrop-memory: saved crop " .. val)
    schedule_save()
end

local function on_end_file()
    -- Mark transition so the "" reset between files is not seen as untoggle.
    ignore_clear_until = mp.get_time() + 1.5
    -- Flush pending state for the outgoing file before current_key changes.
    if save_timer then
        save_timer:kill()
        save_timer = nil
        write_db_now()
    else
        local val = mp.get_property("video-crop", "")
        if current_key and val and val ~= "" then
            db[current_key] = val
            write_db_now()
        end
    end
end

mp.register_script_message("autocrop-memory-clear", function()
    if current_key and db[current_key] then
        db[current_key] = nil
        write_db_now()
        mp.osd_message("Crop memory cleared for this file")
    end
end)

mp.register_script_message("autocrop-memory-clear-all", function()
    db = {}
    write_db_now()
    mp.osd_message("Crop memory cleared for all files")
end)

load_db()
mp.register_event("file-loaded", on_file_loaded)
mp.register_event("end-file", on_end_file)
mp.observe_property("path", "string", on_path)
mp.observe_property("video-crop", "string", on_crop_change)
