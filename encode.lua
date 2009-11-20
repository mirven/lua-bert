require 'types'

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

function Encode:write_string(str)
	local bytes = { str:byte(1, str:len()) }
	for _, b in ipairs(bytes) do
		table.insert(self.out, b)
	end
end

e = Encode:new()
e:write_1(65)
e:write_1(66)
e:write_1(67)
e:write_string("foo")
e:write_string("foobar")

print(e:str())
