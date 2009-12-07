require 'luaspec'
require 'bert'

matchers.should_fail = matchers.should_error

describe["bert decoding"] = function()

	describe["decoding"] = function()
		it["should fail if the first byte is not the proper magic"] = function()
			expect(function() bert.decode "ABCDEF" end).should_fail()
		end		
		
		describe["decoding strings"] = function()
			before = function()
				string = bert.decode { 131, 109, 0, 0, 0, 3, 102, 111, 111 }
			end
			
			it["should return the encoded string"] = function()
				expect(string).should_be("foo")
			end
		end
		
		describe["decoding symbols"] = function()
			before = function()
				sym = bert.decode { 131, 100, 0, 3, 102, 111, 111 }
			end
		
			it["should return the encoded symbol"] = function()
				expect(sym).should_be(s"foo")
			end
		end
		
		describe["decoding tuples"] = function()
			before = function()
				tuple = bert.decode { 131, 104, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99 }
			end
			
			it["should return encoded tuple"] = function()
				expect(bert.tuple.is_tuple(tuple)).should_be(true)
				expect(#tuple).should_be(3)
				expect(tuple[1]).should_be('a')
				expect(tuple[2]).should_be('b')
				expect(tuple[3]).should_be('c')
			end
		end
		
		describe["decoding arrays"] = function()
			before = function()
				array = bert.decode { 131, 108, 0, 0, 0, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 106 }
			end
			
			it["should return encoded array"] = function()
				expect(#array).should_be(3)
				expect(array[1]).should_be('a')
				expect(array[2]).should_be('b')
				expect(array[3]).should_be('c')
			end			
		end
		
		describe["decoding nested arrays"] = function()
			before = function()
				tuple = bert.decode { 131, 108, 0, 0, 0, 4, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 108, 0, 0, 0, 2, 109, 0, 0, 0, 1, 102, 109, 0, 0, 0, 1, 111, 106, 106 }
			end
			
			it["should return encoded array"] = function()
				expect(#tuple).should_be(4)
				expect(tuple[1]).should_be('a')
				expect(tuple[2]).should_be('b')
				expect(tuple[3]).should_be('c')
				expect(tuple[4][1]).should_be('f')
				expect(tuple[4][2]).should_be('o')
			end			
		end
		
		describe["decoding integers"] = function()
			it["should decode 0"] = function()
				number = bert.decode { 131, 97, 0 }
				expect(number).should_be(0)
			end
			
			-- it["should decode -1"] = function()
			-- 	number = bert.decode { 131, 98, 255, 255, 255, 255 }
			-- 	expect(number).should_be(-1)
			-- end
		end
		
		describe["decoding complex objects"] = function()
			it["should decode nil"] = function()
				out = bert.decode { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 3, 110, 105, 108 }
				expect(out).should_be(nil)
			end
			
			it["should decode true"] = function()
				out = bert.decode { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 116, 114, 117, 101 }
				expect(out).should_be(true)
			end
			
			it["should decode false"] = function()
				out = bert.decode { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 5, 102, 97, 108, 115, 101 }
				expect(out).should_be(false)
			end
			
			describe["decoding hashes"] = function()
				it["should decode"] = function()
					hash = bert.decode { 131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 109, 0, 0, 0, 4, 107, 101, 121, 49, 109, 0, 0, 0, 6, 118, 97, 108, 117, 101, 49, 106 }
					expect(hash.key1).should_be("value1")
				end
			end
		end
	end
	
end