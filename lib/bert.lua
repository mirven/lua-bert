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

-- takes either a string of bytes or an array of tyes
function decode(input)
	if type(input) == "table" then
		input = string.char(unpack(input))
	end
	local decoder = d.Decoder:new(input)
	return decoder:read_any()
end