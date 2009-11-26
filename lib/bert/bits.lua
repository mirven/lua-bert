local math = math
local table = table

module('bert.bits')

local function check_int(n)
	-- checking not float
	if n - math.floor(n) > 0 then
		error("trying to use bitwise operation on non-integer!")
	end
end


local function tbl_to_number(tbl)
 local n = table.getn(tbl)

 local rslt = 0
 local power = 1
 for i = 1, n do
  rslt = rslt + tbl[i]*power
  power = power*2
 end
 
 return rslt
end

local function bit_not(n)
 
 local tbl = to_bits(n)
 local size = math.max(table.getn(tbl), 32)
 for i = 1, size do
  if(tbl[i] == 1) then 
   tbl[i] = 0
  else
   tbl[i] = 1
  end
 end
 return tbl_to_number(tbl)
end


function to_bits(n)
	check_int(n)
	if n < 0 then
		-- negative
		return to_bits(bit_not(math.abs(n)) + 1)
	end
	-- to bits table
	local bits = {}
	while n > 0 do
		local state = math.mod(n,2)
		bits[#bits+1] = state		
		n = (n-state)/2
	end

	return bits
end

function byte(n, bits)
	local start_bit = n*8-7
	local end_bit = n*8
	
	local value = 0
	for i=start_bit, end_bit do
		local bit = bits[i]
		if bit ~= nil then
			value = value + bit*(2^(i-start_bit))
		end
	end
	return value
end

function bytes(num, bits)
	local bytes = {}
	for i=1,num do
		local b = byte(i, bits)
		table.insert(bytes, 1, b)
	end
	return bytes
end
