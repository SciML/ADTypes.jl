using ADTypes
using Test

import EnzymeCore

@testset "ADTypes.jl" begin
    adtype = AutoFiniteDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoFiniteDiff
    @test adtype.fdtype === Val(:forward)
    @test adtype.fdjtype === Val(:forward)
    @test adtype.fdhtype === Val(:hcentral)

    adtype = AutoForwardDiff()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoForwardDiff{nothing}

    adtype = AutoForwardDiff(10)
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoForwardDiff{10}

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

    adtype = AutoEnzyme()
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoEnzyme{<:EnzymeCore.ReverseMode}

    adtype = AutoEnzyme(; mode = EnzymeCore.Forward)
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoEnzyme{<:EnzymeCore.ForwardMode}

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

    adtype = AutoSparseForwardDiff(10)
    @test adtype isa ADTypes.AbstractADType
    @test adtype isa AutoSparseForwardDiff{10}
end
