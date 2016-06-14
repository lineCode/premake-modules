local p = premake

p.modules.qtcreator = {}
p.modules.qtcreator._VERSION = p._VERSION

local creator = p.modules.qtcreator
local project = p.project
local m = creator

-- For debug : print table
function m.tprint (tbl, indent)
  if not indent then indent = 0 end
  print('--------------------------')
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      -- print(table.tostring(v))
      -- tprint(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
end

function m.esc(value)
  return value
end

-- Get configuration name
function m.cfgname(cfg)
  local cfgname = cfg.buildcfg
  if cfg.platform then cfgname=cfgname..'_'..cfg.platform end
  return cfgname
end

-- Get target name
-- return :    <ProjectName>_<Configuration>
-- or return : <ProjectName>_<Configuration>_<Platform>
function m.targetname(cfg)
  return cfg.project.name..'_'..m.cfgname(cfg)
end

-- Generate Workspace
function m.generateWorkspace(wks)
  p.eol("\r\n")
  p.indent(" ")
  p.escaper(m.esc)
  p.generate(wks, ".pro", m.workspace.generateQmake)
  -- p.generate(wks, ".pro.shared", m.workspace.generateUser)
  -- p.generate(wks, ".creator.py", m.workspace.generateTemplate)
end

-- Generate Project
function m.generateProject(prj)
  p.eol("\r\n")
  p.indent("  ")
  p.escaper(m.esc)
  -- if project.iscpp(prj) then
  --   p.generate(prj, ".cmake", cmake.project.generate)
  -- end
end

function m.cleanWorkspace(wks)
  p.clean.file(wks, wks.name .. ".txt")
end

function m.cleanProject(prj)
  p.clean.file(prj, prj.name .. ".cmake")
end

function m.cleanTarget(prj)
  -- TODO..
end

-- Set dependence libs in same workspace
-- param modules : The table for dependences
-- param withPlatform : If contains any platform in this workspace or project
function m.linkmodules(modules, withPlatform)
  local target_libs = {}
  local plat = ''
  if withPlatform then plat = '_%{cfg.platform}' end
  for k, v in pairs(modules) do
    table.insert(target_libs, v..'_%{cfg.buildcfg}'..plat)
  end
  links(target_libs)
end

include('_preload.lua')
include("workspace.lua")
include("project.lua")
include("configuration.lua")

return m
