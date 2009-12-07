local Types = require 'bert.types'
local sym = require 'bert.sym'
local tuple = require 'bert.tuple'
local bytes = require 'bert.bytes'

local string = string
local setmetatable = setmetatable
local error = error
local table = table
local type = type
local ipairs = ipairs

module('bert.encoder')

Encoder = {}
Encoder.__index = Encoder

function Encoder:new()
	return setmetatable({ out = {} }, self)
end

function Encoder:str()
	return bytes.to_string(self.out)
end

function Encoder:write_any(obj)
	self:write_1(Types.MAGIC)
	self:write_any_raw(obj)
end

function Encoder:write_any_raw(obj)
	local obj_type = type(obj)
	if obj_type == "string" then
		self:write_binary(obj)
	elseif tuple.is_tuple(obj) then
		self:write_tuple(obj)
	elseif sym.is_symbol(obj) then
		self:write_symbol(obj)
	elseif obj_type == "table" then
		if obj[1] then
			self:write_list(obj)		
		else			
			error "should not happen"
		end		
	elseif obj_type == "number" then
		self:write_fixnum(obj)
	end
end

function Encoder:write_1(byte)
	self.out[#self.out+1] = byte
end

function Encoder:write_2(short)
	local bs = bytes.from_integer(short, 2)
	for i=1,2 do
		self:write_1(bs[i])
	end
end

function Encoder:write_4(long)
	local bs = bytes.from_integer(long, 4)
	for i=1,4 do
		self:write_1(bs[i])
	end
end

function Encoder:write_float(float)
	error "not implemented"
end

function Encoder:write_symbol(sym)
	self:write_1(Types.ATOM)
	self:write_2(sym.name:len())
	self:write_string(sym.name)
end

function Encoder:write_string(str)
	for _, b in ipairs(bytes.from_string(str)) do
		table.insert(self.out, b)
	end
end

function Encoder:write_tuple(data)
	if #data < 256 then
		self:write_1(Types.SMALL_TUPLE)
		self:write_1(#data)
	else
		self:write_1(Types.LARGE_TUPLE)
		self:write_4(#data)
	end
	
	for _, d in ipairs(data) do
		self:write_any_raw(d)
	end
end

function Encoder:write_list(data)
	if #data == 0 then
		self:write_1(Types.NIL)
	else
		self:write_1(Types.LIST)
		self:write_4(#data)
		for _, d in ipairs(data) do
			self:write_any_raw(d)
		end
		self:write_1(Types.NIL)
	end
end

function Encoder:write_binary(data)
	self:write_1(Types.BIN)
	self:write_4(data:len())
	self:write_string(data)
end

function Encoder:write_fixnum(num)
  if num >= 0 and num < 256 then
    self:write_1(Types.SMALL_INT)
    self:write_1(num)
  -- elsif num <= MAX_INT && num >= MIN_INT
	else
    self:write_1(Types.INT)
    self:write_4(num)
  -- else
  --   write_bignum num
  end
end
