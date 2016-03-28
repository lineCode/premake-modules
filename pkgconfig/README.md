## pkg-config loader for Premake5

#### Usage
```lua
pkgconfig.load(<packages>, withlibs)
```
##### example
```lua
local pkgconfig = require "pkgconfig"
workspace "GTKApps"
  ...
  project "GtkUtils"
    kind "StaticLib"
    language "C++"
    -- Load head files
    pkgconfig.load('gtkmm-3.0')

  project "GtkApp"
    kind "ConsoleApp"
    language "C++"
    -- Load head files and link libraries into project
    pkgconfig.load('gtkmm-3.0 zlib', true)
```
