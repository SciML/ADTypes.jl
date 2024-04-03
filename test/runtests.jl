using ADTypes
using Test

struct CustomTag end

@testset "ADTypes.jl" begin
    adtype = AutoChainRules(:ruleconfig_placeholder)
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoChainRules
    @test adtype.ruleconfig == :ruleconfig_placeholder

    adtype = AutoFiniteDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFiniteDiff
    @test adtype.fdtype === Val(:forward)
    @test adtype.fdjtype === Val(:forward)
    @test adtype.fdhtype === Val(:hcentral)

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

    @test adtype isa AutoForwardDiff{nothing, Nothing}

    adtype = AutoForwardDiff(; chunksize = 10, tag = CustomTag())
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoForwardDiff{10, CustomTag}

    adtype = AutoReverseDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoReverseDiff
    @test !adtype.compile

    adtype = AutoReverseDiff(; compile = true)
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoReverseDiff
    @test adtype.compile

    adtype = AutoZygote()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoZygote

    adtype = AutoTracker()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoTracker

    adtype = AutoSparseForwardDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseForwardDiff{nothing, Nothing}

    adtype = AutoSparseForwardDiff(; chunksize = 10, tag = CustomTag())
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseForwardDiff{10, CustomTag}

    adtype = AutoModelingToolkit()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoModelingToolkit
    @test !adtype.obj_sparse
    @test !adtype.cons_sparse

    adtype = AutoModelingToolkit(; obj_sparse = true, cons_sparse = true)
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoModelingToolkit
    @test adtype.obj_sparse
    @test adtype.cons_sparse

    adtype = AutoSparseFiniteDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseFiniteDiff

    adtype = AutoSparseForwardDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseForwardDiff{nothing}

    adtype = AutoEnzyme()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoEnzyme{Nothing}

    # In practice, you would rather specify a
    # `mode::Enzyme.Mode`, e.g. `Enzyme.Reverse` or `Enzyme.Forward`
    adtype = AutoEnzyme(; mode = Val(:Reverse))
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoEnzyme{Val{:Reverse}}

    adtype = AutoDiffractor()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoDiffractor

    adtype = AutoFastDifferentiation()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFastDifferentiation

    adtype = AutoSparseFastDifferentiation()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseFastDifferentiation
end
