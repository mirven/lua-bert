local Types = require 'bert.types'
local sym = require 'bert.sym'
local tuple = require 'bert.tuple'

local setmetatable = setmetatable
local error = error
local string = string
local unpack = unpack


module('bert.decode')

Decoder = {}
Decoder.__index = Decoder

function Decoder:new(str)
	local input = {}
	
	for i=1,str:len() do
		input[#input+1] = str:byte(i)
	end
	return setmetatable({ input = input, current = 1 }, self)
end

function Decoder:read_any()
	if self:read_1() ~= Types.MAGIC then
		error "Bad Magic"
	end
	return self:read_any_raw()
end

function Decoder:read_any_raw()
	local next_byte = self:peek_1()
	if next_byte == Types.ATOM then return self:read_atom()
	elseif next_byte == Types.SMALL_INT then return self:read_small_int()
	elseif next_byte == Types.INT then return self:read_int()
	elseif next_byte == Types.SMALL_BIGNUM then return self:read_small_bignum()
	elseif next_byte == Types.LAGE_BIGNUM then return self:read_large_bignum()
	elseif next_byte == Types.FLOAT then return self:read_float()
	elseif next_byte == Types.SMALL_TUPLE then return self:read_small_tuple()
	elseif next_byte == Types.LARGE_TUPLE then return self:read_large_tuple()
	elseif next_byte == Types.NIL then return self:read_nil()
	elseif next_byte == Types.STRING then return self:read_string()
	elseif next_byte == Types.LIST then return self:read_list()
	elseif next_byte == Types.BIN then return self:read_bin()
	else
		error("Unknown type: "..tostring(next_byte).." at "..tostring(self.current))
	end
end

function Decoder:peek(length)
	local bytes = {}
	
	local start_index = self.current
	local end_index = self.current+length-1
	
	for i=start_index, end_index do
		bytes[#bytes+1] = self.input[i]
	end
	return bytes
end

function Decoder:read(length)	
	local bytes = self:peek(length)
	self.current = self.current + length
	return bytes
end

function Decoder:peek_1()
	return self:peek(1)[1]
end

function Decoder:read_1()
	return self:read(1)[1]
end

function Decoder:read_2()
	local bytes = self:read(2)
	return bytes[2] -- TODO
end

function Decoder:read_4()
	local bytes = self:read(4)
	return bytes[4] -- TODO
end

function Decoder:read_string(length)
	return string.char(unpack(self:read(length)))
end

function Decoder:read_atom()
	if self:read_1() ~= Types.ATOM then error("Invalid Type, not an atom") end
	local length = self:read_2()
	local name = self:read_string(length)
	return sym.s(name)
end

function Decoder:read_small_int()
	if self:read_1() ~= Types.SMALL_INT then error("Invalid Type, not a small int") end
	return self:read_1()
end

function Decoder:read_bin()
	if self:read_1() ~= Types.BIN then error("Invalid Type, not an erlang binary") end
  local length = self:read_4()
  return self:read_string(length)
end

function Decoder:read_dict()
	local type = self:read_1()
	if type ~= Types.LIST and type ~= Types.NIL then error "Invalid dict spec, not an erlang list" end
	
	local length
	if type == Types.LIST then
		length = self:read_4()
	else
		length = 0
	end
	
	local hash = {}
	
	for i=1,length do
		local pair = self:read_any_raw()
		hash[pair[1]] = pair[2]
	end
	if type == Types.LIST then
		self:read_1()
	end
	return hash	
end

function Decoder:read_complex_type(arity)
	local item = self:read_any_raw()
	if item == sym.s"nil" then
		return nil
	elseif item == sym.s"true" then
		return true
	elseif item == sym.s"false" then
		return false
	elseif item == sym.s"time" then
  	-- Time.at(read_any_raw * 1_000_000 + read_any_raw, read_any_raw)
		error "Not Yet Implemented"
	elseif item == sym.s"regex" then
		error "Not Yet Implemented"
	elseif item == sym.s"dict" then
		return self:read_dict()
	else
		return nil
	end	
end

function Decoder:read_tuple(length)
	if length == 0 then return t {} end
	
	local tag = self:read_any_raw()
	if tag == sym.s"bert" then
		return self:read_complex_type()
	else
		local tuple = tuple.t { tag }
		for i=2,length do
			tuple[i] = self:read_any_raw()
		end
		return tuple
	end
end

function Decoder:read_list()
	if self:read_1() ~= Types.LIST then error("Invalid Type, not an erlang list") end
	local length = self:read_4()
	local list = {}
	for i=1,length do
		list[i] = self:read_any_raw()
	end
	self:read_1()
	return list
end

function Decoder:read_small_tuple()
	if self:read_1() ~= Types.SMALL_TUPLE then error("Invalid Type, not a small tuple") end
	local size = self:read_1()
	return self:read_tuple(size)
end

function Decoder:read_large_tuple()
	if self:read_1() ~= Types.LARGE_TUPLE then error("Invalid Type, not a large tuple") end
	local size = self:read_4()
	return self:read_tuple(size)
end