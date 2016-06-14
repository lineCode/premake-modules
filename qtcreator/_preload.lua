local p = premake

newaction {
	trigger         = "qtcreator",
	shortname       = "QtCreator",
	description     = "Generate QtCreator project",

	valid_kinds     = { "ConsoleApp", "WindowedApp", "StaticLib", "SharedLib" },

	valid_languages = { "C", "C++" },

	valid_tools     = {
		cc = { "clang", "gcc" },
	},
	onWorkspace = function(wks)
		p.modules.qtcreator.generateWorkspace(wks)
	end,
	onProject = function(prj)
		-- p.modules.qtcreator.generateProject(prj)
	end,
	onCleanWorkspace = function(wks)
		-- p.modules.qtcreator.cleanWorkspace(wks)
	end,
	onCleanProject = function(prj)
		-- p.modules.qtcreator.cleanProject(prj)
	end,
	onCleanTarget = function(prj)
		-- p.modules.qtcreator.cleanTarget(prj)
	end,
}


--
-- Decide when the full module should be loaded.
--

return function(cfg)
	return (_ACTION == "qmake")
end
