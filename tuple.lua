local Tuple = {}

function t(tuple)
	return setmetatable(tuple, Tuple)
end

function is_tuple(obj)
	return type(obj) == "table" and getmetatable(obj) == Tuple
end

(function()
	local t1 = t { 1, 2, 3 }
	assert(is_tuple(t1))
end)();