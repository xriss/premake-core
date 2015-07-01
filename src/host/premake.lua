
-- we really need LFS
lfs=require("lfs")


premake=premake or {}

	
_PREMAKE_COPYRIGHT	="Copyright (C) 2002-2015 Jason Perkins and the Premake Project"
_PREMAKE_VERSION	="5.0.0-dev"
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
_LUA_DIR=lfs.currentdir() .. "/" .. string.match(arg[0],"(.*/)") .. "/../../"
_LUA_DIR=string.gsub(_LUA_DIR,"//","/")

-- fake command as the dir part is used in later search patha
_PREMAKE_COMMAND	=_LUA_DIR.."premake"

do
	local scripts_path
	for i,v in ipairs(_ARGV) do
		if "/scripts=" ==v:sub(1,9)  then scripts_path=v:sub(10) end
		if "--scripts="==v:sub(1,10) then scripts_path=v:sub(11) end
	end
	print("scripts_path",scripts_path)

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

	table.insert(aa,_LUA_DIR.."src/")
	table.insert(aa,_LUA_DIR.."src/host/")
	
	premake.path=table.concat(aa,";")
	if _OS~="windows" then
		premake.path=premake.path:gsub(":",";") -- cleanup any : seperators
	end

end

-- test the above vars
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


local split = function(str,div,flag)

	if (str=='') then return {""} end
	
	if (div=='') or not div then error("div expected", 2) end
	if (str=='') or not str then error("str expected", 2) end

	local pos,arr = 0,{}

	-- for each divider found
	for st,sp in function() return string.find(str,div,pos,not flag) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end

	if pos~=0 then
		table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	else
		table.insert(arr,str) -- return entire string
	end

	return arr
end

local _dofile=dofile


dofile=function(n)
	local paths=split(premake.path,";")
	for i,path in ipairs(paths) do
		if lfs.attributes(path..n,'mode') then
			return _dofile( path .. n )
		end
	end
	_dofile( _LUA_DIR .. n )
end


dofile( "src/host/criteria.lua" )
dofile( "src/host/debug.lua" )
dofile( "src/host/path.lua" )
dofile( "src/host/os.lua" )
dofile( "src/host/string.lua" )


dofile( "src/_premake_main.lua" )


