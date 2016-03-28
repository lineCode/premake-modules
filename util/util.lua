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

function m.location ()
  return path.getabsolute( outputDir..'/'.._ACTION )
end

function m.binlocation ()
  return path.getabsolute(outputDir..'/'.._ACTION..'/bin/%{cfg.buildcfg}')
end

function m.liblocation ()
  return path.getabsolute(outputDir..'/'.._ACTION..'/lib/%{cfg.buildcfg}')
end

return m;
