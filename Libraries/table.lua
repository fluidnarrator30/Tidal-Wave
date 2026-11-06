const table = table.clone(table)
table.len = function(Tab)
	local Len = 0
	for _ in Tab do
		Len += 1
	end
	
	return Len
end

table.removeValue = function(Tab, Value)
	const Index = table.find(Tab, Value)
	if Index then
		return table.remove(Tab, Value)
	end
	return nil
end

return table