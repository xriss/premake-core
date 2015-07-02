
path=path or {}


path.getrelative=function() print("FUNCTION","path."..debug.getinfo(1).name) end


path.translate=function() print("FUNCTION","path."..debug.getinfo(1).name) end


path.join=function(...)

	local n=path.normalize(table.concat({...},"/"))
--	print("FUNCTION","path."..debug.getinfo(1).name,n)
	
	return n
end



path.isabsolute=function(a)

	local c1=a:sub(1,1)
	local c2=a:sub(2,2)
	
	local r= ( c1=="/" or c1=="\\" or c1=="$" or (c1=="\"" and c2=="$") or (c2==":") )

--	print("FUNCTION","path."..debug.getinfo(1).name,a,r)
	
	return r
	
end

path.getabsolute=function(a)

	local r

	if path.isabsolute(a) then
		r=path.normalize(a)
	else
		r=path.normalize(lfs.currentdir().."/"..a)	
	end

--	print("FUNCTION","path."..debug.getinfo(1).name,a,r)	
	return r
end


path.normalize=function(a)

	local n=a:gsub("\\","/")
	local n=n:gsub("//","/")
	local p=premake._split(a,"/")
	local i=1
	while i<#p do
		local v=p[i]
		if v=="." then
			table.remove(p,i)
		elseif v==".." then
			if i>1 then
				i=i-1
				table.remove(p,i)
				table.remove(p,i)
			else
				i=i+1
			end
		else
			i=i+1
		end
	end
	n=table.concat(p,"/")

--	print("FUNCTION","path."..debug.getinfo(1).name,a,n)
	
	return n
end
