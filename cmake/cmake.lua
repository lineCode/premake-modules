local p = premake

p.modules.cmake = {}
p.modules.cmake._VERSION = p._VERSION

local cmake = p.modules.cmake
local project = p.project

function cmake.tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      -- tprint(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
end

function cmake.cfgname(cfg)
  local cfgname = cfg.buildcfg
  if cfg.platform then cfgname=cfgname..'_'..cfg.platform end
  return cfgname
end

function cmake.targetname(cfg)
  return cfg.project.name..'_'..cmake.cfgname(cfg)
end

function cmake.esc(value)
  return value
end

function cmake.generateWorkspace(wks)
  p.eol("\r\n")
  p.indent("  ")
  p.escaper(cmake.esc)
  wks.filename = "CMakeLists"
  p.generate(wks, ".txt", cmake.workspace.generate)
end

function cmake.generateProject(prj)
  p.eol("\r\n")
  p.indent("  ")
  p.escaper(cmake.esc)

  if project.iscpp(prj) then
    p.generate(prj, ".cmake", cmake.project.generate)
  end
end

function cmake.cleanWorkspace(wks)
  p.clean.file(wks, wks.name .. ".txt")
end

function cmake.cleanProject(prj)
  p.clean.file(prj, prj.name .. ".cmake")
end

function cmake.cleanTarget(prj)
  -- TODO..
end

include('_preload.lua')
include("cmake_workspace.lua")
include("cmake_project.lua")
include("cmake_configuration.lua")

return cmake
