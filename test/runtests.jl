using ADTypes
using Test

@testset "ADTypes.jl" begin
    adtype = AutoFiniteDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFiniteDiff

    adtype = AutoForwardDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoForwardDiff

    adtype = AutoReverseDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoReverseDiff

    adtype = AutoZygote()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoZygote

    adtype = AutoTracker()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoTracker
end
