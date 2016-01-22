require 'BlackJackQVAnalyzer'
require 'BlackJack'
require 'QHash'
require 'VHash'

local tester = torch.Tester()

local mdp = BlackJack()
local qva = BlackJackQVAnalyzer()
TestBlackJackQVAnalyzer = {}
function TestBlackJackQVAnalyzer.test_v_from_q()
    local q = QHash(mdp)
    local v = VHash(mdp)
    local s = {1, 1}
    local a = 1
    q:add(s, a, 1)
    v:add(s, 1)

    s = {2, 1}
    q:add(s, a, 14)
    v:add(s, 14)

    s = {2, 2}
    q:add(s, a, -1)
    v:add(s, 0)

    s = {2, 20}
    q:add(s, a, 0)
    v:add(s, 0)

    local v2 = qva:v_from_q(q)
    tester:assertTensorEq(qva:get_v_tensor(v), qva:get_v_tensor(v2), 0)
end

function TestBlackJackQVAnalyzer.test_q_rms()
    local q1 = QHash(mdp)
    local q2 = QHash(mdp)
    local s = {1, 1}
    local a = 1

    q1:add(s, a, 1)
    q2:add(s, a, 1)

    s = {2, 5}
    a = 2
    q1:add(s, a, 1)
    q2:add(s, a, 2)

    s = {1, 5}
    a = 2
    q1:add(s, a, 2)
    q2:add(s, a, 4)

    tester:asserteq(qva:q_rms(q1, q2), 5)
end
tester:add(TestBlackJackQVAnalyzer)

tester:run()
