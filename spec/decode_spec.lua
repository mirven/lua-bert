require 'luaspec'
require 'bert.decode'

matchers.should_fail = matchers.should_error

function bytes_to_string(bytes)
	return string.char(unpack(bytes))
end

describe["bert decoding"] = function()
	describe["peeking"] = function()
		before = function()
			decoder = bert.Decoder:new("ABCDEF")  -- 65,66,67,68,69
		end
		
		it["should return the correct number of bytes"] = function()
			local bytes = decoder:peek(2)
			expect(#bytes).should_be(2)
			expect(bytes[1]).should_be(65)
			expect(bytes[2]).should_be(66)
		end
		
		it["should not affect the current pointer"] = function()
			expect(decoder.current).should_be(1)
			decoder:peek(2)
			expect(decoder.current).should_be(1)
		end
		
		describe["when current is not at the start"] = function()
			before = function()
				decoder.current = 3
			end
			
			it["should return bytes starting at the current pointer"] = function()
				local bytes = decoder:peek(2)
				expect(#bytes).should_be(2)
				expect(bytes[1]).should_be(67)
				expect(bytes[2]).should_be(68)			
			end
		end		
		
		describe["peeking at 1 byte"] = function()
			before = function()
				byte = decoder:peek_1()
			end
		
			it["should return the byte at the current pointer"] = function()
				expect(byte).should_be(65)
			end
			
			it["should not affect the current pointer"] = function()
				expect(decoder.current).should_be(1)
			end
		end
	end
	
	describe["reading"] = function()
		before = function()
			decoder = bert.Decoder:new("ABCDEF")  -- 65,66,67,68,69
		end
	
		it["should return the correct number of bytes"] = function()
			local bytes = decoder:read(2)
			expect(#bytes).should_be(2)
			expect(bytes[1]).should_be(65)
			expect(bytes[2]).should_be(66)
		end
		
		it["should update the current pointer"] = function()
			expect(decoder.current).should_be(1)
			decoder:read(2)
			expect(decoder.current).should_be(3)
		end
		
		describe["reading at 1 byte"] = function()
			before = function()
				byte = decoder:read_1()
			end
		
			it["should return the byte at the current pointer"] = function()
				expect(byte).should_be(65)
			end
			
			it["should update the current pointer"] = function()
				expect(decoder.current).should_be(2)
			end
		end	
	end
	
	describe["decoding"] = function()
		it["should fail if the first byte is not the proper magic"] = function()
			decoder = bert.Decoder:new("ABCDEF")  -- 65,66,67,68,69
			expect(function() decoder:read_any() end).should_fail()
		end		
		
		describe["decoding strings"] = function()
			before = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 109, 0, 0, 0, 3, 102, 111, 111 })
			end
			
			it["should return the encoded string"] = function()
				expect(decoder:read_any()).should_be("foo")
			end
		end
		
		describe["decoding symbols"] = function()
			before = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 100, 0, 3, 102, 111, 111 })
			end
		
			it["should return the encoded symbol"] = function()
				expect(decoder:read_any()).should_be(bert.sym "foo")
			end
		end
		
		describe["decoding tuples"] = function()
			before = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 104, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99 })
			end
			
			it["should return encoded tuple"] = function()
				local tuple = decoder:read_any()
				expect(bert.is_tuple(tuple)).should_be(true)
				expect(#tuple).should_be(3)
				expect(tuple[1]).should_be('a')
				expect(tuple[2]).should_be('b')
				expect(tuple[3]).should_be('c')
			end
		end
		
		describe["decoding arrays"] = function()
			before = function()
			 	decoder = bert.Decoder:new(bytes_to_string { 131, 108, 0, 0, 0, 3, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 106 })			
			end
			
			it["should return encoded array"] = function()
				local tuple = decoder:read_any()
				expect(#tuple).should_be(3)
				expect(tuple[1]).should_be('a')
				expect(tuple[2]).should_be('b')
				expect(tuple[3]).should_be('c')
			end			
		end
		
		describe["decoding nested arrays"] = function()
			before = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 108, 0, 0, 0, 4, 109, 0, 0, 0, 1, 97, 109, 0, 0, 0, 1, 98, 109, 0, 0, 0, 1, 99, 108, 0, 0, 0, 2, 109, 0, 0, 0, 1, 102, 109, 0, 0, 0, 1, 111, 106, 106 })
			end
			
			it["should return encoded array"] = function()
				local tuple = decoder:read_any()
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
				decoder = bert.Decoder:new(bytes_to_string { 131, 97, 0 })
				number = decoder:read_any()
				expect(number).should_be(0)
			end
		end
		
		describe["decoding complex objects"] = function()
			it["should decode nil"] = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 3, 110, 105, 108 })
				expect(decoder:read_any()).should_be(nil)
			end
			
			it["should decode true"] = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 116, 114, 117, 101 })
				expect(decoder:read_any()).should_be(true)
			end
			
			it["should decode false"] = function()
				decoder = bert.Decoder:new(bytes_to_string { 131, 104, 2, 100, 0, 4, 98, 101, 114, 116, 100, 0, 5, 102, 97, 108, 115, 101 })
				expect(decoder:read_any()).should_be(false)
			end
			
			describe["decoding hashes"] = function()
				it["should decode"] = function()
					decoder = bert.Decoder:new(bytes_to_string { 131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 109, 0, 0, 0, 4, 107, 101, 121, 49, 109, 0, 0, 0, 6, 118, 97, 108, 117, 101, 49, 106 })
					hash = decoder:read_any()
					expect(hash.key1).should_be("value1")
				end
			end
		end
	end
	
end