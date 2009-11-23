local e = require 'bert.encode'
local d = require 'bert.decode'
local c = require 'bert.convert'
local sym = require 'bert.sym'
local tuple = require 'bert.tuple'

local string = string
local type = type
local unpack = unpack

-- Create symbols by s"foo"
s = sym.s

-- Create tuples by t{ 1, 2, 3 }
t = tuple.t

module('bert')


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