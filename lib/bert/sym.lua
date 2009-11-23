local setmetatable = setmetatable
local getmetatable = getmetatable

module('bert.sym')

local Symbols = {}

local function create_sym(name)
	return setmetatable({ name = name }, Symbols)
end

function is_symbol(obj)
	return getmetatable(obj) == Symbols
end

function s(name)
	Symbols[name] = Symbols[name] or create_sym(name)
	return Symbols[name]
end
