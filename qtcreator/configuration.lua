local p = premake
local tree = p.tree
local project = p.project
local config = p.config
local creator = p.modules.qtcreator
creator.config = {}
local m = creator.config
m.elements = {}

-- template
function m.template(cfg)
  local kind = cfg.project.kind
  local template = "app"
  if kind == 'StaticLib' then
    template = "lib"
  elseif kind == 'SharedLib' then
    template = "lib"
  elseif kind == 'ConsoleApp' or kind == 'WindowedApp' then
    template = "app"
  end
  _p(1, "TEMPLATE = %s", template)
end

-- Generate include directories
function m.includedirs(cfg)
  if cfg.includedirs and #cfg.includedirs > 0 then
    _p(1, "INCLUDEPATH += \\")
    for _, includedir in ipairs(cfg.includedirs) do
      local dirpath = project.getrelative(cfg.project, includedir)
      _p(2,"%s \\", dirpath)
    end
    _p(2,'')
  end
end

-- Add files
function m.files(cfg)
  if cfg.files and #cfg.files > 0 then
    _p(1, "SOURCES = \\")
    for i,v in ipairs(cfg.files) do
      _p(2,"%s \\" ,project.getrelative(cfg.project, v))
    end
    _p(2, "")
  end
end

-- Set lib directories
function m.libdirs(cfg)
  if #cfg.libdirs > 0 then
    local libdirs = project.getrelative(cfg.project, cfg.libdirs)
    _p(1, "LIBS += \\")
    for _, libpath in ipairs(libdirs) do
      _p(2, '-L%s \\', libpath)
    end
    _p(2, "")
  end
end

-- Set Link libs
function m.links(cfg)
  local links = config.getlinks(cfg, "system", "fullpath")
  if links and #links>0 then
    local libs = ""
    for _, libname in ipairs(links) do
      libs = libs..'-l'..libname.." "
    end
    _p(1, "LIBS += %s", libs)
  end
end

-- Generate Defines
function m.defines(cfg)
  if cfg.defines and #cfg.defines  > 0 then
    local defs = ""
    for _, define in ipairs(cfg.defines) do
      defs = defs..define.." "
    end
    if #defs > 0 then
      _p(1,'DEFINES += %s',defs)
    end
  end
end

function m.target(cfg)
  _p(1, 'TARGET = %s',creator.targetname(cfg))
end

-- Add executable / libs
function m.config(cfg)
  local kind = cfg.project.kind
  local configs = ""
  if kind == 'StaticLib' then
    configs = configs..' '..'staticlib'
  elseif kind == 'SharedLib' then
    configs = configs..' '..'dll'
  elseif kind == 'ConsoleApp' then
    configs = configs..' '..'console'
  end

  if cfg.flags and #cfg.flags > 0 then
    for _, flag in ipairs(cfg.flags) do
      if flag == 'C++11' then
        configs = configs..' '..'c++11'
      elseif flag == 'C++14' then
        configs = configs..' '..'c++14'
      elseif flag == 'Symbols' then
        configs = configs..' '..'debug'
      elseif flag == 'FatalWarnings' or flag == 'FatalCompileWarnings' then
        configs = configs..' '..'warn_on'
      elseif flag == 'Unicode' then
        _p(1,'DEFINES += UNICODE')
      else
        print("Unknown flag:", flag)
      end
    end
  end
  if #configs > 0 then
    _p(1, "CONFIG += %s", configs)
  end
end

-- Set targets output properties
function m.targetprops(cfg)
  local targetname = cmake.targetname(cfg)
  local filename = cfg.filename
  if cfg.targetname then filename = cfg.targetname end
  if cfg.targetdir and targetname and filename then
    _p(1,'set_target_properties( %s ', targetname)
    _p(2,'PROPERTIES')
    _p(2,'ARCHIVE_OUTPUT_DIRECTORY "%s"', cfg.targetdir)
    _p(2,'LIBRARY_OUTPUT_DIRECTORY "%s"', cfg.targetdir)
    _p(2,'RUNTIME_OUTPUT_DIRECTORY "%s"', cfg.targetdir)
    _p(2,'OUTPUT_NAME  "%s"', filename)
    _p(1,')')
  end
end





-- Generate Call array
function m.elements.generate(cfg)
  return {
    m.target,
    m.template,
    m.defines,
    m.config,
    m.includedirs,
    m.files,
    m.libdirs,
    m.links,
    -- m.targetprops,
  }
end

function m.generate(prj, cfg, index)
  -- creator.tprint(cfg)
  _p("%s {", creator.targetname(cfg))
	p.callArray(m.elements.generate, cfg)
  _p("}")
  _p("")
end

return m
