## QMake/QtCreator Premake5 action

Generate project for QtCreator IDE.

The generated qmake scripts are not good structured but it works with basic project configurations.

## To export peojects

1. Download this repository and extract to [premake module folder]()
2. Put `require('qtcreator')` into your `premake5.lua`
3. Run `premake5 qtcreator`
