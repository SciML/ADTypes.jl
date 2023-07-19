using ADTypes
using Test

@testset "ADTypes.jl" begin
    adtype = AutoFiniteDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFiniteDiff

    adtype = AutoFiniteDifferences()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFiniteDifferences{Nothing}

    # In practice, you would rather specify a
    # `fdm::FiniteDifferences.FiniteDifferenceMethod`, e.g. constructed with
    # `FiniteDifferences.central_fdm` or `FiniteDifferences.forward_fdm`
    adtype = AutoFiniteDifferences(; fdm = Val(:forward))
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFiniteDifferences{Val{:forward}}

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
