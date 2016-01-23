--- Choose epsilon to be N0 / N0 + (# times visited a state)
local DecayTableExplorer, parent =
    torch.class('rl.DecayTableExplorer', 'rl.Explorer')

function DecayTableExplorer:__init(N0, state_table)
    parent.__init(self)
    self.N0 = N0
    self.state_table = state_table
end

function DecayTableExplorer:get_eps(s)
    return self.N0 / (self.N0 + self.state_table:get_value(s))
end
