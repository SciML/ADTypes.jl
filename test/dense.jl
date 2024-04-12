@testset "AutoChainRules" begin
    adtype = AutoChainRules(:ruleconfig_placeholder)
    @test adtype isa AbstractADType
    @test adtype isa AutoChainRules
    @test adtype.ruleconfig == :ruleconfig_placeholder
end

@testset "AutoDiffractor" begin
    adtype = AutoDiffractor()
    @test adtype isa AbstractADType
    @test adtype isa AutoDiffractor
end

@testset "AutoEnzyme" begin
    adtype = AutoEnzyme()
    @test adtype isa AbstractADType
    @test adtype isa AutoEnzyme{Nothing}
    @test adtype.mode === nothing

    # In practice, you would rather specify a
    # `mode::Enzyme.Mode`, e.g. `Enzyme.Reverse` or `Enzyme.Forward`
    adtype = AutoEnzyme(; mode = Val(:Reverse))
    @test adtype isa AbstractADType
    @test adtype isa AutoEnzyme{Val{:Reverse}}
    @test adtype.mode == Val(:Reverse)
end

@testset "AutoFastDifferentiation" begin
    adtype = AutoFastDifferentiation()
    @test adtype isa AbstractADType
    @test adtype isa AbstractSymbolicDifferentiationMode
    @test adtype isa AutoFastDifferentiation
end

@testset "AutoFiniteDiff" begin
    adtype = AutoFiniteDiff()
    @test adtype isa AbstractADType
    @test adtype isa AbstractFiniteDifferencesMode
    @test adtype isa AutoFiniteDiff
    @test adtype.fdtype === Val(:forward)
    @test adtype.fdjtype === Val(:forward)
    @test adtype.fdhtype === Val(:hcentral)
end

@testset "AutoFiniteDifferences" begin
    adtype = AutoFiniteDifferences()
    @test adtype isa AbstractADType
    @test adtype isa AbstractFiniteDifferencesMode
    @test adtype isa AutoFiniteDifferences{Nothing}
    @test adtype.fdm === nothing

    # In practice, you would rather specify a
    # `fdm::FiniteDifferences.FiniteDifferenceMethod`, e.g. constructed with
    # `FiniteDifferences.central_fdm` or `FiniteDifferences.forward_fdm`
    adtype = AutoFiniteDifferences(; fdm = Val(:forward))
    @test adtype isa AbstractADType
    @test adtype isa AutoFiniteDifferences{Val{:forward}}
    @test adtype.fdm == Val(:forward)
end

@testset "AutoForwardDiff" begin
    adtype = AutoForwardDiff()
    @test adtype isa AbstractADType
    @test adtype isa AbstractForwardMode
    @test adtype isa AutoForwardDiff{nothing, Nothing}
    @test adtype.tag === nothing

    adtype = AutoForwardDiff(; chunksize = 10, tag = CustomTag())
    @test adtype isa AbstractADType
    @test adtype isa AbstractForwardMode
    @test adtype isa AutoForwardDiff{10, CustomTag}
    @test adtype.tag == CustomTag()
end

@testset "AutoModelingToolkit" begin
    adtype = AutoModelingToolkit()
    @test adtype isa AbstractADType
    @test adtype isa AbstractSymbolicDifferentiationMode
    @test adtype isa AutoModelingToolkit
    @test !adtype.obj_sparse
    @test !adtype.cons_sparse

    adtype = AutoModelingToolkit(; obj_sparse = true, cons_sparse = true)
    @test adtype isa AbstractADType
    @test adtype isa AbstractSymbolicDifferentiationMode
    @test adtype isa AutoModelingToolkit
    @test adtype.obj_sparse
    @test adtype.cons_sparse
end

@testset "AutoPolyesterForwardDiff" begin
    adtype = AutoPolyesterForwardDiff(; chunksize=10)
    @test adtype isa AbstractADType
    @test adtype isa AbstractForwardMode
    @test adtype isa AutoPolyesterForwardDiff{10}
end

@testset "AutoReverseDiff" begin
    adtype = AutoReverseDiff()
    @test adtype isa AbstractADType
    @test adtype isa AbstractReverseMode
    @test adtype isa AutoReverseDiff
    @test !adtype.compile

    adtype = AutoReverseDiff(; compile = true)
    @test adtype isa AbstractADType
    @test adtype isa AbstractReverseMode
    @test adtype isa AutoReverseDiff
    @test adtype.compile
end

@testset "AutoTracker" begin
    adtype = AutoTracker()
    @test adtype isa AbstractADType
    @test adtype isa AbstractReverseMode
    @test adtype isa AutoTracker
end

@testset "AutoZygote" begin
    adtype = AutoZygote()
    @test adtype isa AbstractADType
    @test adtype isa AbstractReverseMode
    @test adtype isa AutoZygote
end
