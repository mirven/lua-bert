-- todo:
-- function s(name) return Symbol:new(name) end
-- function t(array) return Tuple:new(array) end

module('bert', package.seeall)

local e = require 'bert.encode'
local d = require 'bert.decode'
local c = require 'bert.convert'

function encode(o)
	local complex = c.convert(o)
	local e = e.Encode:new()
	e:write_any(complex)
	return e:str()
end
