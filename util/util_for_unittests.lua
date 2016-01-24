function rl.util.are_testmdp_policy_probabilities_good(
        policy,
        expected_probabilities)
    local n_times_action = {0, 0, 0}
    local n_iters = 10000
    for i = 1, n_iters do
        local state = math.random(1, 2)
        local a = policy:get_action(state)
        n_times_action[a] = n_times_action[a] + 1
    end

    for action = 1, 3 do
        if not rl.util.is_prob_good(
                n_times_action[action],
                expected_probabilities[action],
                n_iters) then
            return false
        end
    end
    return true
end

function rl.util.are_tensors_same_shape(t1, t2)
    if t1:dim() ~= t2:dim() then
        return false
    end
    for d = 1, t1:dim() do
        if (#t1)[d] ~= (#t2)[d] then
            return false
        end
    end
    return true
end

function rl.util.do_qtable_qfunc_match(mdp, q_table, qfunc)
    for _, state in pairs(mdp:get_all_states()) do
        for _, action in pairs(mdp:get_all_actions()) do
            local sa_value = qfunc:get_value(state, action)
            if math.abs(q_table[state][action] - sa_value) > rl.FLOAT_EPS then
                return false
            end
        end
    end
    return true
end

function rl.util.do_vtable_vfunc_match(mdp, v_table, vfunc)
    for _, state in pairs(mdp:get_all_states()) do
        local state_value = vfunc:get_value(state)
        if v_table[state] ~= state_value then
            return false
        end
    end
    return true
end
