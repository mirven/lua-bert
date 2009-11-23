module('bert.tuple', package.seeall)

local Tuple = {}

function t(tuple)
	return setmetatable(tuple, Tuple)
end

function is_tuple(obj)
	return type(obj) == "table" and getmetatable(obj) == Tuple
end