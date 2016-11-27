--[[
@auth   mum-chen
@desc   a cmd tool to simplize the 
@date   
--]]
--======== include and declare constant =======================================
-- local getopt = require('getopt.lua')
local print = require("color-p").print
local utils = require("utils")
local shift = utils.shift
local split = utils.split




--[[
@func:	setport
--------------------
@desc:	set mac-table by mac and port

@param:	
 mac:	only get the last 48bit
  port:	only get the last 2bit
  @return:	
--]]

local t = {}

for i = 1, 10, 1 do
	t[i] = i
end

string.split = split
str = "111:22:33"
t = str:split(":")

-- t = ("1:2:asdas"):split(":")
-- t = split("1:2:sdas", ":")
print(t)
