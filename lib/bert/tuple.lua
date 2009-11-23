local setmetatable = setmetatable
local getmetatable = getmetatable
local type = type

module('bert.tuple')

local Tuple = {}

function Tuple.__eq(t1, t2)
	if not is_tuple(t2) then return false end
	if #t1 ~= #t2 then return false end
	for i=1,#t1 do
		if t1[i] ~= t2[i] then return false end
	end
	return true
end

function t(tuple)
	return setmetatable(tuple, Tuple)
end

function is_tuple(obj)
	return type(obj) == "table" and getmetatable(obj) == Tuple
end