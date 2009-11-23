module('bert.sym', package.seeall)

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

-- Symbol = {}
-- -- Symbol.__index = Symbol
-- 
-- function Symbol:new(name)
-- 	Symbols[name] = Symbols[name] or setmetatable({ name = name }, Symbols)
-- 	return Symbols[name]
-- end
-- 
-- function sym(name)
-- 	Symbols[name] = Symbols[name] or create_sym(name)
-- 	return Symbols[name]
-- end
-- 
-- s = setmetatable({}, {
-- 	__index = function(_, name)
-- 		return sym(name)
-- 	end
-- });
-- 
-- -- should("blah blah bah", function()
-- -- end)
-- 
-- (function()
-- 	assert(type(sym("foo")) == "table")
-- 	assert(sym("foo") == sym("foo"))
-- 	assert(sym("foo") ~= sym("bar"))
-- end)();
-- 
-- (function()
-- 	assert(is_symbol(sym("foo")))
-- 	assert(not is_symbol("string"))
-- 	assert(not is_symbol({}))
-- end)();
-- 
-- (function()
-- 	assert(sym("blah") == s.blah)
-- end)();