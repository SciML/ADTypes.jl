using ADTypes
using Test

struct CustomTag end

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
    @test adtype isa AutoForwardDiff{nothing,Nothing}

    adtype = AutoForwardDiff(; chunksize = 10, tag = CustomTag())
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoForwardDiff{10,CustomTag}

    adtype = AutoReverseDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoReverseDiff

    adtype = AutoZygote()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoZygote

    adtype = AutoTracker()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoTracker

    adtype = AutoSparseForwardDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseForwardDiff{nothing,Nothing}

    adtype = AutoSparseForwardDiff(; chunksize = 10, tag = CustomTag())
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseForwardDiff{10,CustomTag}
end
