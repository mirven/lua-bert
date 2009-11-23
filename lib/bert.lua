module('bert', package.seeall)

require 'bert.encode'
require 'bert.decode'
require 'bert.convert'

function encode(o)
	local complex = convert(o)
	local e = Encode:new()
	e:write_any(complex)
	return e:str()
end
