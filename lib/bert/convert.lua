module('bert', package.seeall)

require 'bert.sym'
require 'bert.tuple'
require 'bert.encode'

local function convert_hash(o)
	local tuples = {}

	for k,v in pairs(o) do
		tuples[#tuples+1] = tuple.t { convert(k), convert(v) }
	end

	return tuple.t { sym.sym("bert"), sym.sym("dict"), tuples }
end

local function convert_tuple(o)
	local items = {}		
	for _, i in ipairs(o) do
		items[#items+1] = convert(i)
	end		
	return tuple.t(items)
end

local function convert_array(o)
	local items = {}		
	for _, i in ipairs(o) do
		items[#items+1] = convert(i)
	end		
	return items
end


function convert(o)
	if o == nil then
		return tuple.t { sym.sym("bert"), sym.sym("nil") }
	elseif type(o) == 'boolean' then
		return tuple.t { sym.s.bert, sym.s[tostring(o)] }
	elseif tuple.is_tuple(o) then
		return convert_tuple(o)
	elseif type(o) == "table" and not sym.is_symbol(o) then
		if o[1] then
			return convert_array(o)
		else
			local h = convert_hash(o)
			return h
		end
	else
		return o
	end
end

