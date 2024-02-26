local oop = require "lib.oop"

local Date = {}

function Date:parse_date(date_str)
  local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%Z"
  local y, m, d, h, min, sec, _ = date_str:match(pattern)
  return os.time { year = y, month = m, day = d, hour = h, min = min, sec = sec }
end

function Date:to_time_ago(seconds)
  local days = seconds / 86400
  if days >= 1 then
    days = math.floor(days)
    return days .. (days == 1 and " day" or " days") .. " ago"
  end

  local hours = (seconds % 86400) / 3600
  if hours >= 1 then
    hours = math.floor(hours)
    return hours .. (hours == 1 and " hour" or " hours") .. " ago"
  end

  local minutes = ((seconds % 86400) % 3600) / 60
  if minutes >= 1 then
    minutes = math.floor(minutes)
    return minutes .. (minutes == 1 and " minute" or " minutes") .. " ago"
  end

  return "Now"
end

return oop(Date)
