using Pkg
using SafeTestsets
using Test
# `using ADTypes` in Main is load-bearing for the printing tests: Julia qualifies a
# type's module in `show` based on visibility in `Base.active_module()` (Main), not the
# module the test runs in. Without it, `string(AutoForwardDiff())` becomes
# "ADTypes.AutoForwardDiff()" and the `startswith(..., "Auto")` assertions fail.
using ADTypes

const GROUP = get(ENV, "GROUP", "All")

function activate_qa_env()
    Pkg.activate(joinpath(@__DIR__, "qa"))
    # On Julia < 1.11 the [sources] section in the qa Project.toml is not honored,
    # so Pkg.develop the package root path explicitly to test the PR branch code.
    if VERSION < v"1.11.0-DEV.0"
        Pkg.develop(PackageSpec(path = dirname(@__DIR__)))
    end
    return Pkg.instantiate()
end

## Tests

if GROUP == "All" || GROUP == "Core"
    @testset verbose = true "ADTypes.jl" begin
        @safetestset "Dense" begin
            include("dense.jl")
        end
        @safetestset "Sparse" begin
            include("sparse.jl")
        end
        @safetestset "Symbols" begin
            include("symbols.jl")
        end
        @safetestset "Legacy" begin
            include("legacy.jl")
        end
        @safetestset "Miscellaneous" begin
            include("misc.jl")
        end
        if VERSION >= v"1.11.0-DEV.469"
            @safetestset "Public" begin
                include("public.jl")
            end
        end
    end
end

if GROUP == "QA"
    activate_qa_env()
    @testset "Quality Assurance" begin
        include(joinpath(@__DIR__, "qa", "qa.jl"))
    end
end
