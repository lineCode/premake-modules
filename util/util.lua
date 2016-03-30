-- Output directory option
newoption {
   trigger     = "outdir",
   value       = "PATH",
   description = "Output directory"
}
-- variable for output directory
local outputDir = _OPTIONS["outdir"] and _OPTIONS["outdir"] or "build"

-- Clean output directory action
newaction {
  trigger = "clean",
  description = "Clear all files genrated.",
  execute = function ()
    local outDirAbs = path.getabsolute( outputDir )
    if( os.get()== "macosx" or  os.get() == "linux" ) then
    --   os.execute("rm -rf "..outDirAbs)
    -- else
      os.rmdir(outDirAbs)
    end
  end
}

local m = {}

-- output directory
function m.outdir ()
  return path.getabsolute( outputDir )
end

-- Get Project output directory
function m.location ()
  return path.getabsolute( outputDir..'/'.._ACTION )
end

-- Get executable binary output directory
-- param withPlatform : If contains any platform in this workspace or project
function m.binlocation (withPlatform)
  local platfm = ''
  if withPlatform then platfm = '/%{cfg.platform}' end
  return path.getabsolute(outputDir..'/'.._ACTION..'/bin/%{cfg.buildcfg}'..platfm)
end

-- Get library binary output directory
-- param withPlatform : If contains any platform in this workspace or project
function m.liblocation (withPlatform)
  local platfm = ''
  if withPlatform then platfm = '/%{cfg.platform}' end
  return path.getabsolute(outputDir..'/'.._ACTION..'/lib/%{cfg.buildcfg}'..platfm)
end

return m;
