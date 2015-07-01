
-- we really need LFS
lfs=require("lfs")


-- premake libs
criteria=criteria or {}
debug=debug or {}
path=path or {}
os=os or {}
string=string or {}

criteria._compile=function()end
criteria._delete=function()end
criteria.matches=function()end

path.getabsolute=function()end
path.getrelative=function()end
path.isabsolute=function()end
path.join=function()end
path.normalize=function()end
path.translate=function()end

debug.prompt=function()end

os.chdir=function()end
os.chmod=function()end
os.copyfile=function()end
os._is64bit=function()end
os.isdir=function()end
os.getcwd=function()end
os.getversion=function()end
os.isfile=function()end
os.islink=function()end
os.locate=function()end
os.matchdone=function()end
os.matchisfile=function()end
os.matchname=function()end
os.matchnext=function()end
os.matchstart=function()end
os.mkdir=function()end
os.pathsearch=function()end
os.realpath=function()end
os.rmdir=function()end
os.stat=function()end
os.uuid=function()end
os.writefile_ifnotequal=function()end

string.endswith=function()end
string.hash=function()end
string.sha1=function()end
string.startswith=function()end

	
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


_PREMAKE_COMMAND	=arg[-1].." "..arg[0]

_ARGV=arg

--hack, linux only for now to get started
_HOST_DIR=lfs.currentdir() .. "/" .. string.match(arg[0],"(.*/)") .. "/"
_HOST_DIR=string.gsub(_HOST_DIR,"//","/")

-- test the above vars
for n,v in pairs(_G) do
	if type(n)=="string" then
		if string.sub(n,1,1)=="_" then
			print(n,tostring(v))
		end
	end
end



