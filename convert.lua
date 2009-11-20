
_bert = {}
_nil = {}
_dict = {}

function encode_table(o)
	local tuples = {}

	for k,v in pairs(o) do
		tuples[#tuples+1] = { k, v }
	end

	return { _bert, _dict, tuples }
end

function encode(o)
	if o == nil then
		return { _bert, _nil }
	elseif type(o) == "table" then
		return encode_table(o)
	end
end


encode(nil)


arr = encode { foo = "bar "}
assert(type(arr) == "table")
assert(type(arr[3]) == "table")
assert(type(arr[3][1]) == "table")

