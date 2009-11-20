require 'types'
require 'sym'

Encode = {}
Encode.__index = Encode

function Encode:new()
	return setmetatable({ out = {} }, self)
end

function Encode:str()
	return string.char(unpack(self.out))
end

function Encode:write_any(obj)
	self:write_1(Types.MAGIC)
	self:write_any_raw(obj)
end

function Encode:write_any_raw(obj)
	local obj_type = type(obj)
	if obj_type == "string" then
		self:write_string(obj)
	end
end

function Encode:write_1(byte)
	self.out[#self.out+1] = byte
end

function Encode:write_2(short)
end

function Encode:write_4(long)
end

function Encode:write_float(fload)
end

function Encode:write_boolean(bool)
end

function Encode:write_symbol(sym)
	self.write_1(Types.ATOM)
	self.write_2(#sym.name)
	self.write_string(symname)
end

function Encode:write_string(str)
	local bytes = { str:byte(1, str:len()) }
	for _, b in ipairs(bytes) do
		table.insert(self.out, b)
	end
end

function Encode:write_tuple(data)
	if #data < 256 then
		self:write_1(Types.SMALL_TUPLE)
		self.write_1(#data)
	else
		self:write_1(Types.LARGE_TUPLE)
		self.write_4(#data)
	end
	
	for _, d in ipairs(data) do
		self:write_any_raw(d)
	end
end

function Encode:write_list(data)
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

(function()
	local e = Encode:new()
	e:write_1(65)
	assert(e:str() == "A")
end)();

(function()
	local e = Encode:new()
	e:write_1(65)
	e:write_1(66)
	e:write_1(67)
	assert(e:str() == "ABC")
end)();

(function()
	local e = Encode:new()
	e:write_string("abc")
	assert(e:str() == "abc")
end)();
