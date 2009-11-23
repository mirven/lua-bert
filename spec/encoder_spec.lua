require 'luaspec'
require 'bert'

function matchers.should_encode_to(value, expected)
	local encoded_value = bert.encode(value)
	local expected_string = string.char(unpack(expected))
	if encoded_value ~= expected_string then
		return false, "expecting "..tostring(expected)..", not ".. tostring(value)
	else
		return true
	end
end


-- Test cases are gotten by comparing equivelemtn encodings in the ruby library
-- e.g. BERT::Encoder::encode(t[ 'a', 'b', 'c' ]).unpack 'C*'

describe["bert encoding"] = function()
	it["should encode strings"] = function()
		expect("foo").should_encode_to { 131, 109, 0, 0, 0, 3, 102, 111, 111 }
	end
	
	it["should encode symbols"] = function()
		expect(s"foo").should_encode_to { 131, 100, 0, 3, 102, 111, 111 }
	end
	
	it["should encode tuples"] = function()
		expect(t{ 'a', 'b', 'c' }).should_encode_to { 131, 104, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99 }
	end

	it["should encode arrays"] = function()
		expect({ 'a', 'b', 'c' }).should_encode_to { 131, 108, 0, 0, 0, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 106 }
	end
	
	it["should encode nestered arrays"] = function()
		expect({ 'a','b','c', { 'f', 'o' } }).should_encode_to { 131, 108, 0, 0, 0, 4, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 108, 0, 0, 0, 2, 109, 0, 0, 0, 1, 102, 109, 0, 0, 0, 1, 111, 106, 106 }
	end
	
	it["should encode numbers less than 256"] = function()
		expect(45).should_encode_to { 131, 97, 45 }
	end

	it["should encode 256"] = function()
		expect(256).should_encode_to { 131, 98, 0, 0, 1, 0 }
	end

	it["should encode 0"] = function()
		expect(0).should_encode_to { 131, 97, 0 }
	end

	it["should encode numbers greater than 256"] = function()
		expect(1000).should_encode_to { 131, 98, 0, 0, 3, 232 }
	end
	
	it["should encode nil"] = function()
		expect(nil).should_encode_to { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 3, 110, 105, 108 }
	end

	it["should encode true"] = function()
		expect(true).should_encode_to { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 116, 114, 117, 101 }
	end

	it["should encode false"] = function()
		expect(false).should_encode_to { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 5, 102, 97, 108, 115, 101 }
	end

	it["should encode tables used as hashes"] = function()
		expect({ key1 = "value1" }).should_encode_to { 131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 109, 0, 0, 0, 4, 107, 101, 121, 49, 109, 0, 0, 0, 6, 118, 97, 108, 117, 101, 49, 106 }
	end

	-- it["should encode tables used as hashes 2"] = function()
	-- 	s = encode { [sym(key1)] = "value1" }
	-- 	assert_bytes(s, { 131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 100, 0, 4, 107, 101, 121, 49, 109, 0, 0, 0, 6, 118, 97, 108, 117, 101, 49, 106 })
	-- end
	
end
