local easy21 = require 'easy21'
local cp = require 'custompolicies'

math.randomseed(os.time())
local a = rl.Agent(easy21)
local episode = a.get_episode(cp.get_threshold_policy(14))
print("*** Printing Episode ***")
for t, data in pairs(episode) do
    local s, a, Gt = table.unpack(data)
    print("t = " .. t)
    print("\ts = ")
    print(s)
    print("\ta = " .. a)
    print("\tGt = " .. Gt)
end
