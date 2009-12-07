local table = table
local string = string
local unpack = unpack 

module('bert.bytes')

function to_integer(bytes)
	local num = 0	
	for i=1,#bytes do
		local byte_offset = 2^((#bytes-i)*8)
		num = num + bytes[i] * byte_offset
	end	
	return num
end

function from_integer(num, n)
	local bytes = {}
	
	while num > 0 do
		local v = num % 256
		table.insert(bytes, 1, v)
		num = (num - v) / 256
	end
	
	if n then
		if n < #bytes then
			for i=1,#bytes-n do
				table.remove(bytes,1)
			end
		else
			for i=1,n-#bytes do
				table.insert(bytes, 1, 0)
			end
		end
	end
		
	return bytes
end

function to_string(bytes)
	return string.char(unpack(bytes))
end

function from_string(str)
	return { str:byte(1, str:len()) }
end