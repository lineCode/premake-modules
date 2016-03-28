-- Get output content by call system command
function callCommand(cmd)
  return io.popen(cmd):read('*a')
end

-- Split string into a table with sep
function splitStr(str, sep)
  local t = {}
  for w in string.gmatch(str,"([^"..sep.."]+)") do
    table.insert(t, string.sub(w,3,#w))
  end
  return t
end

function getIncludeDirs(exepath, pkg)
  local cmd = exepath..' --cflags-only-I '..pkg
  local res = callCommand(cmd)
  if res then
    return splitStr(res, ' ')
  end
end
function getLibDirs(exepath, pkg)
  local cmd = exepath..' --libs-only-L '..pkg
  local res = callCommand(cmd)
  if res then
    return splitStr(res, ' ')
  end
end

function getLibs(exepath, pkg)
  local cmd = exepath..' --libs-only-l '..pkg
  local res = callCommand(cmd)
  if res then
    return splitStr(res, ' ')
  end
end

local m = {}
m.exepath = 'pkg-config'

function m.load(pkg, withlibs)
  local include_dirs = getIncludeDirs(m.exepath, pkg)
  includedirs(include_dirs)
  if withlibs then
    local lib_dirs = getIncludeDirs(m.exepath, pkg)
    local libs     = getLibs(m.exepath, pkg)
    libdirs(lib_dirs)
    links(libs)
  end
end

return m
