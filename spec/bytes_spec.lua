require 'luaspec'
require 'bert.bytes'

describe["extracting bytes from integer"] = function()
	it["should return the bytes, most significant first"] = function()
		bs = bert.bytes.from_integer(0)
		expect(#bs).should_be(0)

		bs = bert.bytes.from_integer(1)
		expect(#bs).should_be(1)
		expect(bs[1]).should_be(1)

		bs = bert.bytes.from_integer(2^8)
		expect(#bs).should_be(2)
		expect(bs[1]).should_be(1)
		expect(bs[2]).should_be(0)

		bs = bert.bytes.from_integer(2^16-1)
		expect(#bs).should_be(2)
		expect(bs[1]).should_be(255)
		expect(bs[2]).should_be(255)

		bs = bert.bytes.from_integer(2^16)
		expect(#bs).should_be(3)
		expect(bs[1]).should_be(1)
		expect(bs[2]).should_be(0)
		expect(bs[3]).should_be(0)
	end
end

describe["extracting a specified number of bytes"] = function()
	describe["when the number of bytes matches the number requested"] = function()
		it["should pad 0's at the beginning"] = function()
			bs = bert.bytes.from_integer(0, 2)
			expect(#bs).should_be(2)
			expect(bs[1]).should_be(0)
			expect(bs[2]).should_be(0)

			bs = bert.bytes.from_integer(1,2)
			expect(#bs).should_be(2)
			expect(bs[1]).should_be(0)
			expect(bs[2]).should_be(1)
		end
	end

	describe["when the number of bytes matches the number requested"] = function()
		it["should return the bytes"] = function()
			bs = bert.bytes.from_integer(2^8,2)
			expect(#bs).should_be(2)
			expect(bs[1]).should_be(1)
			expect(bs[2]).should_be(0)

			bs = bert.bytes.from_integer(2^16-1,2)
			expect(#bs).should_be(2)
			expect(bs[1]).should_be(255)
			expect(bs[2]).should_be(255)
		end
	end
	
	
	describe["when there are more bytes than requested"] = function()
		it["should only return the number of bytes requested"] = function()
			bs = bert.bytes.from_integer(2^16, 2)
			expect(#bs).should_be(2)
			expect(bs[1]).should_be(0)
			expect(bs[2]).should_be(0)
		end
	end
end

describe["converting numbers to a byte array and vice versa"] = function()
	it["should decode to same value that was encoded"] = function()
		for i=1,2^12 do
			expect(bert.bytes.to_integer(bert.bytes.from_integer(i))).should_be(i)
		end	
		
		for _, i in ipairs { 2^16-1, 2^16, 2^16+1, 2^24-1, 2^24, 2^24+1, 2^32-1, 2^32, 2^32+1 } do
			expect(bert.bytes.to_integer(bert.bytes.from_integer(i))).should_be(i)
		end
	end
end

