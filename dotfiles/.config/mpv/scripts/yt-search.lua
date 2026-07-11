table.unpack = table.unpack or unpack

local utils = require('mp.utils')
local msg = require('mp.msg')

local SCRIPT_NAME = mp.get_script_name()

local cfg = {
  limit = 10,
  keybinding = 'CTRL+SHIFT+s',
}

local state = {
  results = {},
}

local function fmt_duration(seconds)
  if not seconds then return '' end
  local s = math.floor(tonumber(seconds) or 0)
  local m = math.floor(s / 60)
  local h = math.floor(m / 60)
  s = s % 60
  m = m % 60
  if h > 0 then
    return string.format('%d:%02d:%02d', h, m, s)
  end
  return string.format('%d:%02d', m, s)
end

local function truncate(str, max_len)
  if not str then return '' end
  str = tostring(str)
  if #str > max_len then
    return str:sub(1, max_len - 1) .. '…'
  end
  return str
end

local function fetch_results(query)
  local result = utils.subprocess({
    args = {
      'yt-dlp',
      '--flat-playlist',
      '--dump-json',
      '--no-warnings',
      '--no-check-certificate',
      'ytsearch' .. cfg.limit .. ':' .. query,
    },
    cancellable = false,
  })
  if result.status ~= 0 then
    local err = (result.stderr or ''):match('[^\n]+')
    return nil, err or 'exit code ' .. result.status
  end
  return result.stdout, nil
end

local function parse_results(output)
  local items = {}
  if not output then return items end
  for line in output:gmatch('[^\r\n]+') do
    local ok, info = pcall(utils.parse_json, line)
    if ok and info and info.title then
      local hint = {}
      if info.channel or info.uploader then
        hint[#hint + 1] = info.channel or info.uploader
      end
      local d = fmt_duration(info.duration)
      if d ~= '' then hint[#hint + 1] = d end
      local url = info.webpage_url or info.url
      items[#items + 1] = {
        title = truncate(info.title, 80),
        hint = table.concat(hint, ' · '),
        icon = 'play_circle',
        value = url,
      }
    end
  end
  return items
end

local function open_results_menu(items)
  mp.commandv('script-message-to', 'uosc', 'open-menu', utils.format_json({
    type = 'yt_search_results',
    title = 'YouTube Search',
    search_style = 'on_demand',
    footnote = 'Type to filter results',
    callback = {SCRIPT_NAME, 'yt-search-event'},
    items = items,
  }))
end

local function open_error_menu(err)
  mp.commandv('script-message-to', 'uosc', 'open-menu', utils.format_json({
    type = 'yt_search_results',
    title = 'YouTube Search',
    items = {{
      title = 'Search failed',
      hint = err,
      icon = 'error',
      selectable = false,
      muted = true,
    }},
  }))
end

local function open_no_results_menu()
  mp.commandv('script-message-to', 'uosc', 'open-menu', utils.format_json({
    type = 'yt_search_results',
    title = 'YouTube Search',
    items = {{
      title = 'No results found',
      hint = 'Try a different search query',
      selectable = false,
      muted = true,
    }},
  }))
end

local function open_search_prompt()
  mp.commandv('script-message-to', 'uosc', 'open-menu', utils.format_json({
    type = 'yt_search_prompt',
    title = 'YouTube Search',
    search_style = 'palette',
    search_debounce = 'submit',
    on_search = 'callback',
    callback = {SCRIPT_NAME, 'yt-search-event'},
    footnote = 'Type a query and press Enter',
    items = {{
      title = 'Search YouTube',
      selectable = false,
      muted = true,
    }},
  }))
end

local function perform_search(query)
  if not query or query == '' then return end

  mp.commandv('script-message-to', 'uosc', 'close-menu', 'yt_search_prompt')
  mp.osd_message('Searching YouTube for "' .. query .. '"...', 60)
  local output, err = fetch_results(query)
  mp.osd_message('', 0)

  if err then
    msg.warn('yt-search: search failed for "' .. query .. '": ' .. err)
    open_error_menu(err)
    return
  end

  local items = parse_results(output)
  if #items == 0 then
    open_no_results_menu()
    return
  end

  state.results = items
  open_results_menu(items)
end

mp.register_script_message('yt-search-event', function(json)
  if not json then return end
  local ok, event = pcall(utils.parse_json, json)
  if not ok or not event then return end
  if event.type == 'search' then
    perform_search(event.query)
  elseif event.type == 'activate' then
    local count = mp.get_property_number('playlist-count', 0)
    local mode = count > 0 and 'append' or 'replace'
    mp.commandv('loadfile', event.value, mode)
    if mode == 'append' then
      local item = state.results[event.index]
      local title = item and item.title or 'Video'
      mp.osd_message('Added to playlist: ' .. title, 3)
    end
    mp.commandv('script-message-to', 'uosc', 'close-menu', 'yt_search_results')
  end
end)

mp.add_key_binding(cfg.keybinding, 'search_youtube', function()
  open_search_prompt()
end)
