require 'luaspec'

require 'tuple'

describe["tuples"] = function()
	before = function()
		tuple = t { 1,2,3 }
	end
	
	it["should be able to check that it is a tuple"] = function()
		expect(is_tuple(tuple)).should_be(true)
	end
end