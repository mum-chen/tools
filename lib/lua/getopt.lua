--[[
@auth   mum-chen
@desc   a cmd tool to simplize the 
@date   
--]]
--======== include and extern variable & function ===========================
local utils = require("./utils")

local split = utils.split

local verbose = false

--======== include and declare constant =======================================
--[[
set a CMD_MAP item
CMD_MAP[cmd] = {
	num  = num,  -- the max needed number
	type = type, -- the param-allocat-type
	func = func, -- the deal function callback
}
K:cmd
V:func,
V:num,	0~inf
V:type	value type:
	U{Unlimit}    allocat in a easy way
	N{Necessary}  do the best to meet that requirment, default value
--]]
local CMD_MAP = {}

--======== private function ===================================================
--[[
@func:	_setting_parse
--------------------
@desc:	
	parse setting pattern, input pattern, return cmd, args_num, type
@param:	
pattern:
	expect format "cmd[:num[:type] ]"
	default num:0, type:N
	detail in note of CMD_MAP
@return:
	if success, return cmd, args_num, args_type(U/N)
	else, return nil, error
--]]
local function _setting_parse(pattern)
	if type(pattern) then
		return nil, "the patter expect string"
	end

	local cmd, num, _type, err

	local arr, err = split(pattern, ":")
	if not (arr or arr[1]) then
		return nil, "pattern error, not get cmd"
	end

	cmd = arr[1]
	num = tonumber(arr[2])
	_type = arr[3]

	if not num or num < 0 then
		num = 0
	end
	
	if "U" ~= _type then 
		_type = "N"
	end

	return cmd, num, _type
end

--[[
@func:	_main_parse
--------------------
@desc:	
	parse command line input, input table, shift the table
@param:	
@return:
	case success,   return cmd, num, params(table format)
	case empty cmd, return nil, nil, params
	case error,     return nil, error, nil
	case fin,       return nil, nil, nil
	
	case error or fin the params will return nil,
	else the params will always table-type even param is empty
--]]
local function _main_parse(args)
	-- TODO
	local cmd, num, params
	params = {}
	cmd  = args[1]:math("--(.*)")
end



--[[
@func:	_reorder
--------------------
@desc:	
	U means Unlimit, N means Necessary, detail in CMD_MAP
	the function will reorder the param,
	that will first allocat type N, and then allocat U by order
	for example
	reorder param
	args input: -abc a1 a2 a3 a4 -d
	case	a:1:N; b:1:N; c:1:U
		-a a1 -b a2 -c a3 -d
	case	a:1:N; b:1:N; c:3:U
		-a a1 -b a2 -c a3 a4 -d
	case	a:1:N; b:1:N; c:1:N 
		-a a1 -b a2 -c a3 -d
	case	a:3:N; b:1:N; c:1:N
		-a a1 a2 a3 -b -c -d
	case	a:3:U; b:1:N; c:1:N
		-a a1 a2 -b a3 -c a4 -d
	case	a:3:U; b:2:N; c:1:N
		-a a1 a2 a3 -b -c a4 -d
@param:	
cmd	more than one short cmd, such as -abc
params	
@return:
	parms array
--]]
local function _reorder(cmd, params)
	local cmd_array = {}
	local bool, err
	for w in cmd:gmatch("%w") do
		local _cmd= CMD_MAP[w]
		if not _cmd then
			bool, err = _unimplemented(w)
			if not bool then
				return bool, err
			end -- else continue
		else
			local obj = {
				name = w,
				num = _cmd.num,
				type = _cmd.type,
				begin = nil,
				len = nil,
			}
			table.insert(cmd_array, obj)
		end
	end

	--[[
		resize the cmd_array
		return success, finish(N), remainder(N)
	--]]
	local function resize(num)

	end

	-- init falg
	local free = #param
	local preemptable = 0
	local last = 1

	for i, item in ipairs(cmd_array) do
		if item.num <= item.free then -- case fit
			if item.type = "U" then -- if Unlimit param
				-- record the preemptable-info
				-- preemptable
				preemptable = preemptable + item.num
			end
			item.begin = last
			item.len = item.num
		elseif  -- case type N, and num < number + n

	end

end

--[[
@func:	_rebuild
--------------------
@desc:	
	rebuild line input, reorder depend on setting pattern.
	That will rebuild long-parameter & short-parameter:
		--all to -all
		-abc to -a -b -c
	And the function will reorder the param, that will first allocat type N,
	and then allocat U by order, detail in _reorder.
@param:	
args:	command line input, expect table format
@return:
	table
--]]
local function _rebuild(args)
	-- TODO
	local result = {}
	local reorder = {}
	local isreorder = false
	local reorder_cmd = nil

	-- dispatch the param into result or reorder
	for i, param in ipairs(args) do
		-- TODO test hook, string match
		local prefix, word = string.match(param, "(%-*)(.-)")

		if #prefix == 1 and #word > 1 then
			isreorder = true
			reorder[word] = {}
			reorder_cmd = "-" .. word
		elseif #prefix == 0 then -- param
			if isreorder then
				table.insert(reorder[reorder_cmd], param)
			else
				table.insert(result, param)
			end
		else  -- long-cmd | only one short-cmd 
			isreorder = false
			table.insert(result, "-" .. param)
		end
	end

	-- params is the params' table
	for cmd, params in pairs(reorder) do
		-- the arr contain the cmd & params
		local arr = _reorder(cmd, params)

		for _, param in ipairs(arr) do

			table.insert(return, param)
		end
	end

	return result
end

local function _lakeparams(cmd, expect, fact)
	local err = string.format("cmd:%s expect got %d params, "
		"only got %d", cmd, expect, fact)
	print(err)
	return false, err
end

local function _unimplemented(cmd)
	local err = "the cmd:" .. cmd .. "you input is unimplemented"
	print(err)
	return false, err
end

local function _default(args)
	local err = "the input args don't have cmd"
	print(err)
	return false, err
end

--======== public function ====================================================
local function setdefault(func, type)
	typecheck(func, "function", "setopt", 3)
	if "D" == type then
		_default = func
	elseif "U" == type then
		_unimplemented = func
	elseif "L" == type then
		_lakeparams = func	
	else
		local usage = [[
		    setdefault(func, D|U|L),
		    U: set the unimplemented function, called in unimplemented-cmd input
		    L: set the lakeparams function, called in the necessary param requirement could't meet
		    D: set the default function, called in the param with null-cmd
		]]
		error(usage, 2)
	end
end

--[[
	expect format "cmd[:num[:type] ]"
	default num:0, type:N
	detail in note of CMD_MAP
--]]
local function setopt(pattern, func)
	typecheck(func, "function", "setopt", 3)
	local cmd, num, _type = _setting_parse(pattern)
	if not cmd then 
		error(num, 2) -- return nil, err
	end

	CMD_MAP[cmd] = {
		num = num,
		type = type,
		func = func,
	}
end

local function complex(...)
	local args = {...}
	args = _rebuild(args)
	local cmd, num, params
	local bool, err

	while true do
		cmd, num, params = _main_parse(table)
		if not cmd then
			-- this time num is error,
			-- not num means the _main_parse fin
			if not (num and params) then
				return
			else if params then
				bool, err = _default(params)
				if not bool then
					return bool, err
				end
			else
				print("coplex error:cmd got nil," num)
				return cmd, num
			end
		end

		local item = CMD_MAP[cmd]
		if item.type == "N" and num < item.num then
			bool, err = _lakeparams(cmd, item.num, num)
			if not bool then
				return bool, err
			end
		end

		item.func(unpack(params))
	end
end

local function reduce(...)

end

---------- retuern entry -------------------------------------------------------
return {
	-- recommend function
	setopt = setopt,
	reduce = reduce,
	complex = complex,
	setdefault = setdefault,
	-- others function
	_rebuild_param = _rebuild,
	_main_parse = _main_parse,
	_setting_parse = _setting_parse,
}
