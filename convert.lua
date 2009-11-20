require 'sym'

function encode_table(o)
	local tuples = {}

	for k,v in pairs(o) do
		tuples[#tuples+1] = { k, v }
	end

	return { sym("bert"), sym("dict"), tuples }
end

function encode(o)
	if o == nil then
		return { sym("bert"), sym("nil") }
	elseif type(o) == "table" then
		return encode_table(o)
	end
end

-- function compare_tables(t1, t2)
-- 	for key, value in pairs(t1) do
-- 		if 
-- 	end
-- end


(function()
	local arr = encode(nil)
	assert(#arr == 2)
	assert(arr[1] == sym("bert"))
	assert(arr[2] == sym("nil"))
end)();

(function()
	local arr = encode { foo = "bar" }
	assert(type(arr) == "table")
	assert(type(arr[3]) == "table")
	assert(type(arr[3][1]) == "table")
end)();



