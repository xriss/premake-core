
criteria=criteria or {}

criteria._compile=function() print("FUNCTION","criteria."..debug.getinfo(1).name) end
criteria._delete=function() print("FUNCTION","criteria."..debug.getinfo(1).name) end
criteria.matches=function() print("FUNCTION","criteria."..debug.getinfo(1).name) end

