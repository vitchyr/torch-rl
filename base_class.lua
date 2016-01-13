local M = {}

do
    local Name = torch.class('Name')

    function Name:__init(foo)
        self.lambda = foo
    end

    function Name:bar(x)
        return x
    end
end
M.Name = Name

return M
