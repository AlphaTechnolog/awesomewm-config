local tbl = {}

function tbl.contains(iterator, element, target)
  for _, value in iterator(target) do
    if value == element then
      return true
    end
  end

  return false
end

function tbl.contains_key(element, target)
  for key, _ in pairs(target) do
    if key == element then
      return true
    end
  end

  return false
end

function tbl.filter(tbl, iterator, cb)
  local ret = {}
  for k, v in iterator(tbl) do
    if cb(k, v) then
      ret[k] = v
    end
  end

  return ret
end

function tbl.find(tbl, iterator, cb)
  local query = tbl.filter(tbl, iterator, cb)
  if #query == 0 then
    return nil
  end
  return query[1]
end

function tbl.extract(iterator, target)
  local res = {}

  for _, value in iterator(target) do
    table.insert(res, tostring(value))
  end

  return table.concat(res, ", ")
end

function tbl.extract_keys(target)
  local res = {}

  for key, _ in pairs(target) do
    table.insert(res, tostring(key))
  end

  return table.concat(res, ", ")
end

return tbl
