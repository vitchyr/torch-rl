
local tester = torch.Tester()

local TestTensorUtil = {}
function TestTensorUtil.test_apply_to_slices()
    local function power_fill(tensor, i, power)
        power = power or 1
        tensor:fill(i ^ power)
    end
    local A = torch.Tensor(2, 2)
    local B = torch.Tensor(2, 2)
    B[1][1] = 1
    B[1][2] = 1
    B[2][1] = 2
    B[2][2] = 2
    tester:assertTensorEq(
        rl.util.apply_to_slices(A, 1, power_fill),
        B,
        0)
end

function TestTensorUtil.fill_range()
    local A = torch.Tensor(2, 2)
    local B = torch.Tensor(2, 2)
    B[1][1] = -1
    B[1][2] = -1
    B[2][1] = 0
    B[2][2] = 0
    tester:assertTensorEq(
        rl.util.apply_to_slices(A, 1, rl.util.fill_range, -2),
        B,
        0)

    B[1][1] = 123
    B[2][1] = 123
    B[1][2] = 124
    B[2][2] = 124
    tester:assertTensorEq(
        rl.util.apply_to_slices(A, 2, rl.util.fill_range, 122),
        B,
        0)
end

tester:add(TestTensorUtil)

tester:run()
