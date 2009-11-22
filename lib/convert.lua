require 'sym'
require 'tuple'
require 'encode'

local function convert_hash(o)
	local tuples = {}

	for k,v in pairs(o) do
		tuples[#tuples+1] = t { convert(k), convert(v) }
	end

	return t { sym("bert"), sym("dict"), tuples }
end

local function convert_tuple(o)
	local items = {}		
	for _, i in ipairs(o) do
		items[#items+1] = convert(i)
	end		
	return t(items)
end

local function convert_array(o)
	local items = {}		
	for _, i in ipairs(o) do
		items[#items+1] = convert(i)
	end		
	return items
end


function convert(o)
	if o == nil then
		return t { sym("bert"), sym("nil") }
	elseif type(o) == 'boolean' then
		return t { s.bert, s[tostring(o)] }
	elseif is_tuple(o) then
		return convert_tuple(o)
	elseif type(o) == "table" and not is_symbol(o) then
		if o[1] then
			return convert_array(o)
		else
			local h = convert_hash(o)
			return h
		end
	else
		return o
	end
end

function encode(o)
	local complex = convert(o)
	local e = Encode:new()
	e:write_any(complex)
	return e:str()
end
