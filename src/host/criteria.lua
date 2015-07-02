
criteria=criteria or {}


criteria._delete=function() print("FUNCTION","criteria."..debug.getinfo(1).name) end


criteria._compile=function(ps)

--	print("FUNCTION","criteria."..debug.getinfo(1).name)
	
	for i,v in ipairs(ps) do
--		print(tostring(i))
		for i,v in ipairs(v) do
--			print("\t",tostring(i))
			for i,v in ipairs(v) do
--				print("\t\t",tostring(v))
			end
		end
	end
	
	
	return ps
end


criteria.matches=function(a,b)

	print("FUNCTION","criteria."..debug.getinfo(1).name,a,b)
	
	return false
	
end


