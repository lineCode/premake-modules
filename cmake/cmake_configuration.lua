local p = premake
local tree = p.tree
local project = p.project
local config = p.config
local cmake = p.modules.cmake
cmake.config = {}
local m = cmake.config
m.elements = {}

function m.targetname(cfg)
  return
end

function m.libdirs(cfg)
  if #cfg.libdirs > 0 then
    _p('')
    _p(1,'set(LIB_DIRS')
    local libdirs = project.getrelative(cfg.project, cfg.libdirs)
    for _, libpath in ipairs(libdirs) do
      _p(2, libpath)
    end
    _p(1,')')
    _p(1,'link_directories(${LIB_DIRS})')
  end
end

function m.target(cfg)
  local kind = cfg.project.kind
  local targetname = cmake.targetname(cfg)
  if kind == 'StaticLib' then
    _p(1,'add_library( %s STATIC ${SRC})', targetname)
  elseif kind == 'SharedLib' then
    _p(1,'add_library( %s SHARED ${SRC})', targetname)
  elseif kind == 'ConsoleApp' or kind == 'WindowedApp' then
    _p(1,'add_executable( %s ${SRC})', targetname)
  else

  end
end

function m.links(cfg)
  local links = config.getlinks(cfg, "system", "fullpath")
  if links and #links>0 then
    _p('')
    _p(1, 'set(LIBS ')
    for _, libname in ipairs(links) do
      _p(2, libname)
    end
    _p(1, ')')
    local targetname = cmake.targetname(cfg)
    _p(1, 'target_link_libraries(%s ${LIBS})', targetname)
  end
end

function m.files(cfg)
  if cfg.files then
    _p('')
    _p(1, "set(SRC ")
    for i,v in ipairs(cfg.files) do
      _p(2, project.getrelative(cfg.project, v))
    end
    _p(1, ")")
  end
end

function m.defines(cfg)
  if cfg.defines and #cfg.defines then
    _p('')
    _p(1,'add_definitions(')
    for _, define in ipairs(cfg.defines) do
      _p(2, '-D%s', define)
    end
    _p(1,')')
  end
end

function m.flags(cfg)
  if cfg.flags and #cfg.flags > 0 then
    for _, flag in ipairs(cfg.flags) do
      if flag == 'C++11' then
        _p(1, 'set(CMAKE_CXX_STANDARD 11)')
      elseif flag == 'C++14' then
        _p(1, 'set(CMAKE_CXX_STANDARD 14)')
      end
    end
  end
end

function m.includedirs(cfg)
  if cfg.includedirs and #cfg.includedirs > 0 then
    _p('')
    _p(1,'set(INCLUD_DIRS ')
    for _, includedir in ipairs(cfg.includedirs) do
      local dirpath = project.getrelative(cfg.project, includedir)
      _p(2, dirpath)
    end
    _p(1,')')
    _p(1,'include_directories(${INCLUD_DIRS})')
  end
end

function m.elements.generate(cfg)
  return {
    m.flags,
    m.defines,
    m.includedirs,
    m.libdirs,
    m.files,
    m.target,
    m.links
  }
end

function m.generate(prj, cfg)
	p.callArray(m.elements.generate, cfg)
  cmake.tprint(cfg.flags)
end
