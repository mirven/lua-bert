require 'luaspec'
local tuple = require 'bert.tuple'

describe["tuples"] = function()
	before = function()
		t = tuple.t { 1,2,3 }
	end
	
	it["should be able to check that it is a tuple"] = function()
		expect(tuple.is_tuple(t)).should_be(true)
	end
end