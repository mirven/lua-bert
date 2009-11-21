require 'luaspec'
require 'luamock'

require 'convert'

function assert_bytes(str, bytes)
	assert(str:len() == #bytes)
	for i=1,str:len() do
		assert(str:byte(i) == bytes[i])
	end
end

describe["bert encoding"] = function()
	it["should encode strings"] = function()
		s = encode("foo")
		assert_bytes(s, { 131, 109, 0, 0, 0, 3, 102, 111, 111 })
	end
	
	it["should encode symbols"] = function()
		s = encode(sym "foo")
		assert_bytes(s, { 131, 100, 0, 3, 102, 111, 111 })
	end
	
	it["should encode tuples"] = function()
		s = encode(t { 'a', 'b', 'c' })
		assert_bytes(s, { 131, 104, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99 })
	end

	it["should encode arrays"] = function()
		s = encode { 'a', 'b', 'c' }
		assert_bytes(s, { 131, 108, 0, 0, 0, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 106 })
	end
	
	it["should encode nestered arrays"] = function()
		s = encode { 'a','b','c', { 'f', 'o' } }
		assert_bytes(s, { 131, 108, 0, 0, 0, 4, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 108, 0, 0, 0, 2, 109, 0, 0, 0, 1, 102, 109, 0, 0, 0, 1, 111, 106, 106 })
	end
	
	it["should encode numbers less than 256"] = function()
		s = encode(45)
		assert_bytes(s, { 131, 97, 45 })
	end

	it["should encode 256"] = function()
		s = encode(256)
		assert_bytes(s, { 131, 98, 0, 0, 1, 0 })
	end

	it["should encode 0"] = function()
		s = encode(0)
		assert_bytes(s, { 131, 97, 0 })
	end

	it["should encode numbers greater than 256"] = function()
		s = encode(1000)
		assert_bytes(s, { 131, 98, 0, 0, 3, 232 })
	end
	
	it["should encode nil"] = function()
		s = encode(nil)
		assert_bytes(s, { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 3, 110, 105, 108 })
	end

	it["should encode true"] = function()
		s = encode(true)
		assert_bytes(s, { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 116, 114, 117, 101 })
	end

	it["should encode false"] = function()
		s = encode(false)
		assert_bytes(s, { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 5, 102, 97, 108, 115, 101 })
	end
	

	-- it["should encode tables used as hashes"] = function()
	-- 	s = encode { key1 = "value1" }
	-- 	assert_bytes(s, { 131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 100, 0, 4, 107, 101, 121, 49, 109, 0, 0, 0, 6, 118, 97, 108, 117, 101, 49, 106 })
	-- end
	
end
