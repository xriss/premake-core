
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
_BASE_SCRIPT_DIR=lfs.currentdir() .. "/" .. string.match(arg[0],"(.*/)") .. "/../../"
_BASE_SCRIPT_DIR=string.gsub(_BASE_SCRIPT_DIR,"//","/")

-- fake command as the dir part is used in later search patha
_PREMAKE_COMMAND	=_BASE_SCRIPT_DIR.."premake"

_SCRIPT=lfs.currentdir() .. "/" .. arg[0]
_SCRIPT_DIR=lfs.currentdir() .. "/" .. string.match(arg[0],"(.*/)")

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

	table.insert(aa,_BASE_SCRIPT_DIR.."src")
	table.insert(aa,_BASE_SCRIPT_DIR.."src/host")
	
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


dofile( _BASE_SCRIPT_DIR .. "src/host/criteria.lua" )
dofile( _BASE_SCRIPT_DIR .. "src/host/debug.lua" )
dofile( _BASE_SCRIPT_DIR .. "src/host/path.lua" )
dofile( _BASE_SCRIPT_DIR .. "src/host/os.lua" )
dofile( _BASE_SCRIPT_DIR .. "src/host/string.lua" )

local _dofile=dofile
dofile=function(n)

	local p=os.locate(n) or n

--print("DOFILE",n,p,lfs.currentdir())

	local pd,pf=path._splitpath(p)
	
	local OLD_SCRIPT=_SCRIPT
	local OLD_SCRIPT_DIR=_SCRIPT_DIR

	 _SCRIPT=p
	 _SCRIPT_DIR=pd
	 
	 local old_cd=lfs.currentdir()
	 lfs.chdir(_SCRIPT_DIR)
--	 print("CD1",_SCRIPT_DIR,pf)

	local a,b=_dofile(p)
	
	 lfs.chdir(old_cd)
--	 print("OD",old_cd)
	_SCRIPT=OLD_SCRIPT
	_SCRIPT_DIR=OLD_SCRIPT_DIR
	
	return a,b
end

local _loadfile=loadfile
loadfile=function(n)

	local p=path.getabsolute(n)
--print("LOADFILE",n,p)
	local pd,pf=path._splitpath(p)
	
	local OLD_SCRIPT=_SCRIPT
	local OLD_SCRIPT_DIR=_SCRIPT_DIR

	 _SCRIPT=p
	 _SCRIPT_DIR=pd
	 
	 local old_cd=lfs.currentdir()
	 lfs.chdir(_SCRIPT_DIR)
--	 print("CD2",_SCRIPT_DIR,pf)

	local a,b=_loadfile(n)

-- reseting the dir will break the next include so leave it hanging
-- problem is the loadfile chunk is not run until later

--	 lfs.chdir(old_cd)
--	 print("OD",old_cd)
--	_SCRIPT=OLD_SCRIPT
--	_SCRIPT_DIR=OLD_SCRIPT_DIR

	return a,b
end

dofile( _BASE_SCRIPT_DIR .. "src/_premake_main.lua" )
_premake_main()
