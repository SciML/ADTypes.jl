using ADTypes
using Aqua: Aqua
using JET: JET
using Test

@testset "Aqua.jl" begin
    Aqua.test_all(ADTypes; deps_compat = (check_extras = false,))
end

@testset "JET.jl" begin
    JET.test_package(ADTypes, target_defined_modules = true)
end
