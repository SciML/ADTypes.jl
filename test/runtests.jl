using SafeTestsets
using SciMLTesting
# `using ADTypes` in Main is load-bearing for the printing tests: Julia qualifies a
# type's module in `show` based on visibility in `Base.active_module()` (Main), not the
# module the test runs in. Without it, `string(AutoForwardDiff())` becomes
# "ADTypes.AutoForwardDiff()" and the `startswith(..., "Auto")` assertions fail.
using ADTypes

run_tests(;
    core = function ()
        @safetestset "Dense" include("dense.jl")
        @safetestset "Sparse" include("sparse.jl")
        @safetestset "Symbols" include("symbols.jl")
        @safetestset "Legacy" include("legacy.jl")
        @safetestset "Miscellaneous" include("misc.jl")
        return if VERSION >= v"1.11.0-DEV.469"
            @safetestset "Public" include("public.jl")
        end
    end,
    qa = (;
        env = joinpath(@__DIR__, "qa"),
        body = joinpath(@__DIR__, "qa", "qa.jl")
    ),
)
