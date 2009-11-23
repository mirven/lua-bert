require 'luaspec'
local sym = require 'bert.sym'

describe["symbols"] = function()
	it["should create the same symbol from the same string"] = function()
		expect(sym.sym("foo")).should_be(sym.sym("foo"))
	end

	it["should create different symbols from different strings"] = function()
		expect(sym.sym("foo")).should_not_be(sym.sym("bar"))
	end
	
	it["should be able to provide it's name"] = function()
		expect(sym.sym("foo").name).should_be("foo")
	end
	
	describe["checking to see if an object is a symbol"] = function()
		it["should return true when passed a symbol"] = function()
			expect(sym.is_symbol(sym.sym("foo"))).should_be(true)
		end
		
		it["should return false when passed anything else"] = function()
			expect(sym.is_symbol({})).should_be(false)
			expect(sym.is_symbol()).should_be(false)
			expect(sym.is_symbol(true)).should_be(false)
			expect(sym.is_symbol("foo")).should_be(false)
		end
	end
	
end