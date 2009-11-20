require 'sym'
require 'tuple'

local function convert_hash(o)
	local tuples = {}

	for k,v in pairs(o) do
		tuples[#tuples+1] = { k, v }
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
	elseif type(o) == "table" then
		if o[1] then
			return convert_array(o)
		else
			return convert_hash(o)
		end
	end
end

(function()
	local arr = convert(nil)
	assert(is_tuple(arr))
	assert(#arr == 2)
	assert(arr[1] == sym("bert"))
	assert(arr[2] == sym("nil"))
end)();

(function()
	local arr = convert(true)
	assert(is_tuple(arr))
	assert(#arr == 2)
	assert(arr[1] == sym("bert"))
	assert(arr[2] == sym("true"))
end)();

(function()
	local arr = convert(false)
	assert(is_tuple(arr))
	assert(#arr == 2)
	assert(arr[1] == sym("bert"))
	assert(arr[2] == sym("false"))
end)();

(function()
	local arr = convert { foo = "bar" }
	assert(type(arr) == "table")
	assert(type(arr[3]) == "table")
	assert(type(arr[3][1]) == "table")
end)();




