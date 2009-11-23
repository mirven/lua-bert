require 'luaspec'
require 'bert'

describe["decoding encodings"] = function()
	it["should decode to the same value that was encoded"] = function()
		expect(bert.decode(bert.encode("foo"))).should_be("foo")
		expect(bert.decode(bert.encode(10))).should_be(10)
		expect(bert.decode(bert.encode(s"abc"))).should_be(s"abc")
		expect(bert.decode(bert.encode(true))).should_be(true)
		expect(bert.decode(bert.encode(false))).should_be(false)
		expect(bert.decode(bert.encode(nil))).should_be(nil)
		expect(bert.decode(bert.encode(t{ 'a', 'b', 'c' }))).should_be(t{ 'a', 'b', 'c' })
	end
end