require 'luaspec'

require 'bits'

function is_equal(v1, v2)
	if type(v1) ~= type(v2) then
		return false
	end
	
	if type(v1) == "table" and v1[1] then 
		if #v1 ~= #v2 then
			return false
		end
		for i=1,#v1 do
			if v1[i] ~= v2[i] then
				return false
			end
		end
		return true	
	end
	
	return v1 == v2
end

function matchers.should_have_bits(value, expected)
	if not is_equal(to_bits(value), expected) then
		return false, "expecting "..tostring(expected)..", not ".. tostring(value)
	end
	return true
end


describe["converting an integer to bit array"] = function()
	it["should 0"] = function()
		zero = to_bits(0)
		expect(#zero).should_be(0)
	end

	it["should 1"] = function()
		expect(1).should_have_bits { 1 }
	end	
	
	it["should 2"] = function()
		expect(2).should_have_bits { 0,1 }
	end
	
	it["should 3"] = function()
		expect(3).should_have_bits { 1,1 }
	end
	
	it["should 4"] = function()
		expect(4).should_have_bits { 0,0,1 }
	end
	
	it["should 8"] = function()
		expect(8).should_have_bits { 0,0,0,1 }
	end
end

describe["extracting a byte from an integer"] = function()
	it["should"] = function()
		for i=1,255 do
			expect(byte(1,to_bits(i))).should_be(i)
		end
	end
	
	it["should not"] = function()
		expect(byte(1, to_bits(256))).should_be(0)
		expect(byte(1, to_bits(257))).should_be(1)
		expect(byte(1, to_bits(258))).should_be(2)
		
		expect(byte(2, to_bits(256))).should_be(1)
	end
end

describe["extracing all bytes from an integer"] = function()
	it["should"] = function()
		bb = bytes(2, to_bits(256))
		expect(bb[1]).should_be(1)
		expect(bb[2]).should_be(0)
	end
end
