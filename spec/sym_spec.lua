require 'luaspec'
require 'bert.sym'

describe["symbols"] = function()
	it["should create the same symbol from the same string"] = function()
		expect(bert.sym("foo")).should_be(bert.sym("foo"))
	end

	it["should create different symbols from different strings"] = function()
		expect(bert.sym("foo")).should_not_be(bert.sym("bar"))
	end
	
	it["should be able to provide it's name"] = function()
		expect(bert.sym("foo").name).should_be("foo")
	end
	
	describe["checking to see if an object is a symbol"] = function()
		it["should return true when passed a symbol"] = function()
			expect(bert.is_symbol(bert.sym("foo"))).should_be(true)
		end
		
		it["should return false when passed anything else"] = function()
			expect(bert.is_symbol({})).should_be(false)
			expect(bert.is_symbol()).should_be(false)
			expect(bert.is_symbol(true)).should_be(false)
			expect(bert.is_symbol("foo")).should_be(false)
		end
	end
	
end