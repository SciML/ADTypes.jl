using ADTypes
using Test

@testset "ADTypes.jl" begin
    adtype = AutoFiniteDiff()
    @test adtype isa AbstractADType
    @test adtype isa AutoFiniteDiff

    adtype = AutoForwardDiff()
    @test adtype isa AbstractADType
    @test adtype isa AutoForwardDiff

    adtype = AutoReverseDiff()
    @test adtype isa AbstractADType
    @test adtype isa AutoReverseDiff

    adtype = AutoZygote()
    @test adtype isa AbstractADType
    @test adtype isa AutoZygote

    adtype = AutoTracker()
    @test adtype isa AbstractADType
    @test adtype isa AutoTracker
end
