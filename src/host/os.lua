
os=os or {}

os.chdir=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.chmod=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.copyfile=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os._is64bit=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.isdir=function() print("FUNCTION","os."..debug.getinfo(1).name) end

os.getversion=function() print("FUNCTION","os."..debug.getinfo(1).name) end

os.islink=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.matchdone=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.matchisfile=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.matchname=function() print("FUNCTION","os."..debug.getinfo(1).name) end


os.mkdir=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.pathsearch=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.realpath=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.rmdir=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.stat=function() print("FUNCTION","os."..debug.getinfo(1).name) end
os.writefile_ifnotequal=function() print("FUNCTION","os."..debug.getinfo(1).name) end

os.matchstart=function(a)
	print("FUNCTION","os."..debug.getinfo(1).name,a)
end
os.matchnext=function(a)
	print("FUNCTION","os."..debug.getinfo(1).name,a)
end

os.uuid=function()

	local r=string.format("%04X%04X-%04X-%04X-%04X-%04X%04X%04X",
		math.random(0,0xffff),math.random(0,0xffff),
		math.random(0,0xffff),math.random(0,0xffff),math.random(0,0xffff),
		math.random(0,0xffff),math.random(0,0xffff),math.random(0,0xffff))
		
--	print("FUNCTION","os."..debug.getinfo(1).name,r)

	return r
end



os.getcwd=function()

--	print("FUNCTION","os."..debug.getinfo(1).name)
	
	return lfs.currentdir()
	
end

os.isfile=function(a)

	local r=lfs.attributes(a,'mode')=="file"

--	print("FUNCTION","os."..debug.getinfo(1).name,a,r)
	
	return r
end


os.locate=function(a)

	if lfs.attributes(a,'mode')=="file" then return a end
	
	local r
	local paths=premake._split(premake.path,";")
	for i,p in ipairs(paths) do
		local t=path.normalize(p.."/"..a)
		if lfs.attributes(t,'mode')=="file" then r=t break end
	end

--	print("FUNCTION","os."..debug.getinfo(1).name,a,r)

	return r
end


	
	

