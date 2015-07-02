
-- we really need LFS
lfs=require("lfs")


premake=premake or {}

	
_PREMAKE_COPYRIGHT	="Copyright (C) 2002-2015 Jason Perkins and the Premake Project"
_PREMAKE_VERSION	="5.0.0-lua"
_PREMAKE_URL		="https://github.com/premake/premake-core/wiki"
_OS					="other"

-- jit knows the OS, but it might need tweaking to fit what names premake uses
if jit then
	_OS=string.lower(jit.os)
end

_USER_HOME_DIR		=os.getenv("HOME")
_WORKING_DIR		=lfs.currentdir()



_ARGV=arg

--hack, probably linux only for now to get started
_SCRIPT_DIR=lfs.currentdir() .. "/" .. string.match(arg[0],"(.*/)") .. "/../../"
_SCRIPT_DIR=string.gsub(_SCRIPT_DIR,"//","/")

-- fake command as the dir part is used in later search patha
_PREMAKE_COMMAND	=_SCRIPT_DIR.."premake"

do
	local scripts_path
	for i,v in ipairs(_ARGV) do
		if "/scripts=" ==v:sub(1,9)  then scripts_path=v:sub(10) end
		if "--scripts="==v:sub(1,10) then scripts_path=v:sub(11) end
	end
	if scripts_path then print("scripts_path =",scripts_path) end

	local env_path=os.getenv("PREMAKE_PATH");

	local aa={}
	table.insert(aa,".")
	if scripts_path then table.insert(aa,scripts_path) end
	if env_path then table.insert(aa,env_path) end
	table.insert(aa,_USER_HOME_DIR.."/.premake")
	if _OS=="osx" then
		table.insert(aa,_USER_HOME_DIR.."/Library/Application Support/Premake")
	end
	table.insert(aa,"/usr/local/share/premake;/usr/share/premake")

	table.insert(aa,_SCRIPT_DIR.."src")
	table.insert(aa,_SCRIPT_DIR.."src/host")
	
	premake.path=table.concat(aa,";")
	if _OS~="windows" then
		premake.path=premake.path:gsub(":",";") -- cleanup any : seperators
	end

end

--[[ test the above vars
for n,v in pairs(_G) do
	if type(n)=="string" then
		if string.sub(n,1,1)=="_" then
			print(n,tostring(v))
		end
	end
end
for n,v in pairs(premake) do
	if type(n)=="string" then
		print("premake."..n,tostring(v))
	end
end
]]

local _dofile=dofile

_dofile( _SCRIPT_DIR .. "src/host/criteria.lua" )
_dofile( _SCRIPT_DIR .. "src/host/debug.lua" )
_dofile( _SCRIPT_DIR .. "src/host/path.lua" )
_dofile( _SCRIPT_DIR .. "src/host/os.lua" )
_dofile( _SCRIPT_DIR .. "src/host/string.lua" )

dofile=function(n)
	return _dofile(os.locate(n) or n)
end


dofile( _SCRIPT_DIR .. "src/_premake_main.lua" )
_premake_main()
