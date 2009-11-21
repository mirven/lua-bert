require 'luaspec'

require 'sym'

describe["symbols"] = function()
	it["should create the same symbol from the same string"] = function()
		expect(sym("foo")).should_be(sym("foo"))
	end

	it["should create different symbols from different strings"] = function()
		expect(sym("foo")).should_not_be(sym("bar"))
	end
	
	it["should be able to provide it's name"] = function()
		expect(sym("foo").name).should_be("foo")
	end
	
	describe["checking to see if an object is a symbol"] = function()
		it["should return true when passed a symbol"] = function()
			expect(is_symbol(sym("foo"))).should_be(true)
		end
		
		it["should return false when passed anything else"] = function()
			expect(is_symbol({})).should_be(false)
			expect(is_symbol()).should_be(false)
			expect(is_symbol(true)).should_be(false)
			expect(is_symbol("foo")).should_be(false)
		end
	end
	
end