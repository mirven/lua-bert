require 'luaspec'
require 'bert.bits'

-- function is_equal(v1, v2)
-- 	if type(v1) ~= type(v2) then
-- 		return false
-- 	end
-- 	
-- 	if type(v1) == "table" and v1[1] then 
-- 		if #v1 ~= #v2 then
-- 			return false
-- 		end
-- 		for i=1,#v1 do
-- 			if v1[i] ~= v2[i] then
-- 				return false
-- 			end
-- 		end
-- 		return true	
-- 	end
-- 	
-- 	return v1 == v2
-- end

function matchers.should_have_bits(value, expected)
	local function arrays_equal(v1, v2)
		if #v1 ~= #v2 then return false end
		for i=1,#v1 do 
			if v1[i] ~= v2[i] then
				return false
			end
		end
		return true
	end
	
	if not arrays_equal(bert.to_bits(value), expected) then
		return false, "expecting "..tostring(expected)..", not ".. tostring(value)
	else
		return true
	end
end


describe["converting an integer to bit array"] = function()
	it["should extract bits from integer in reverse order"] = function()
		expect(0).should_have_bits {}
		expect(1).should_have_bits { 1 }
		expect(2).should_have_bits { 0,1 }
		expect(3).should_have_bits { 1,1 }
		expect(4).should_have_bits { 0,0,1 }
		expect(8).should_have_bits { 0,0,0,1 }
	end
end

describe["extracting a byte from an integer"] = function()
	it["should"] = function()
		for i=1,255 do
			expect(bert.byte(1,bert.to_bits(i))).should_be(i)
		end
	end
	
	it["should not"] = function()
		expect(bert.byte(1, bert.to_bits(256))).should_be(0)
		expect(bert.byte(1, bert.to_bits(257))).should_be(1)
		expect(bert.byte(1, bert.to_bits(258))).should_be(2)
		expect(bert.byte(2, bert.to_bits(256))).should_be(1)
	end
end

describe["extracing all bytes from an integer"] = function()
	it["should"] = function()
		bb = bert.bytes(2, bert.to_bits(256))
		expect(#bb).should_be(2)
		expect(bb[1]).should_be(1)
		expect(bb[2]).should_be(0)
	end
end
