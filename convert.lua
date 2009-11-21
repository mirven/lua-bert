require 'sym'
require 'tuple'
require 'encode'

local function convert_hash(o)
	local tuples = {}

	for k,v in pairs(o) do
		tuples[#tuples+1] = t { k, v }
	end

	return { sym("bert"), sym("dict"), tuples }
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
			return convert_hash(o)
		end
	else
		return o
	end
end

function encode(o)
	local complex = convert(o)
	local e = Encode:new()
	e:write_any(o)
	return e:str()
end

-- (function()
-- 	local arr = convert(nil)
-- 	assert(is_tuple(arr))
-- 	assert(#arr == 2)
-- 	assert(arr[1] == sym("bert"))
-- 	assert(arr[2] == sym("nil"))
-- end)();
-- 
-- (function()
-- 	local arr = convert(true)
-- 	assert(is_tuple(arr))
-- 	assert(#arr == 2)
-- 	assert(arr[1] == sym("bert"))
-- 	assert(arr[2] == sym("true"))
-- end)();
-- 
-- (function()
-- 	local arr = convert(false)
-- 	assert(is_tuple(arr))
-- 	assert(#arr == 2)
-- 	assert(arr[1] == sym("bert"))
-- 	assert(arr[2] == sym("false"))
-- end)();
-- 
-- (function()
-- 	local arr = convert { foo = "bar" }
-- 	assert(type(arr) == "table")
-- 	assert(type(arr[3]) == "table")
-- 	assert(type(arr[3][1]) == "table")
-- end)();

-- print(encode(1))
-- print(encode("foo"))

-- s = encode("foo")
-- s = encode(sym "foo")
s = encode({'a','b','c', {'f', 'o'}}) -- works!

bytes = {}

for i=1,s:len() do
	bytes[#bytes+1] = s:byte(i)
end

print("[ "..table.concat(bytes, ", ").." ]")






