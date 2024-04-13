@testset "AutoChainRules" begin
    ad = AutoChainRules(; ruleconfig = ForwardOrReverseRuleConfig())
    @test ad isa AbstractADType
    @test ad isa AutoChainRules{ForwardOrReverseRuleConfig}
    @test ad.ruleconfig == ForwardOrReverseRuleConfig()
    @test mode(ad) isa ForwardOrReverseMode

    ad = AutoChainRules(; ruleconfig = ForwardRuleConfig())
    @test ad isa AbstractADType
    @test ad isa AutoChainRules{ForwardRuleConfig}
    @test ad.ruleconfig == ForwardRuleConfig()
    @test mode(ad) isa ForwardMode

    ad = AutoChainRules(; ruleconfig = ReverseRuleConfig())
    @test ad isa AbstractADType
    @test ad isa AutoChainRules{ReverseRuleConfig}
    @test ad.ruleconfig == ReverseRuleConfig()
    @test mode(ad) isa ReverseMode
end

@testset "AutoDiffractor" begin
    ad = AutoDiffractor()
    @test ad isa AbstractADType
    @test ad isa AutoDiffractor
    @test mode(ad) isa ForwardMode
end

@testset "AutoEnzyme" begin
    ad = AutoEnzyme()
    @test ad isa AbstractADType
    @test ad isa AutoEnzyme{Nothing}
    @test ad.mode === nothing
    @test mode(ad) isa ForwardOrReverseMode

    ad = AutoEnzyme(; mode = EnzymeCore.Forward)
    @test ad isa AbstractADType
    @test ad isa AutoEnzyme{typeof(EnzymeCore.Forward)}
    @test ad.mode == EnzymeCore.Forward
    @test mode(ad) isa ForwardMode

    ad = AutoEnzyme(; mode = EnzymeCore.Reverse)
    @test ad isa AbstractADType
    @test ad isa AutoEnzyme{typeof(EnzymeCore.Reverse)}
    @test ad.mode == EnzymeCore.Reverse
    @test mode(ad) isa ReverseMode
end

@testset "AutoFastDifferentiation" begin
    ad = AutoFastDifferentiation()
    @test ad isa AbstractADType
    @test ad isa AutoFastDifferentiation
    @test mode(ad) isa SymbolicMode
end

@testset "AutoFiniteDiff" begin
    ad = AutoFiniteDiff()
    @test ad isa AbstractADType
    @test ad isa AutoFiniteDiff
    @test mode(ad) isa FiniteDifferencesMode
    @test ad.fdtype === Val(:forward)
    @test ad.fdjtype === Val(:forward)
    @test ad.fdhtype === Val(:hcentral)
end

@testset "AutoFiniteDifferences" begin
    ad = AutoFiniteDifferences(; fdm = nothing)
    @test ad isa AbstractADType
    @test ad isa AutoFiniteDifferences{Nothing}
    @test mode(ad) isa FiniteDifferencesMode
    @test ad.fdm === nothing

    ad = AutoFiniteDifferences(; fdm = Val(:forward))
    @test ad isa AbstractADType
    @test ad isa AutoFiniteDifferences{Val{:forward}}
    @test mode(ad) isa FiniteDifferencesMode
    @test ad.fdm == Val(:forward)
end

@testset "AutoForwardDiff" begin
    ad = AutoForwardDiff()
    @test ad isa AbstractADType
    @test ad isa AutoForwardDiff{nothing, Nothing}
    @test mode(ad) isa ForwardMode
    @test ad.tag === nothing

    ad = AutoForwardDiff(; chunksize = 10, tag = CustomTag())
    @test ad isa AbstractADType
    @test ad isa AutoForwardDiff{10, CustomTag}
    @test mode(ad) isa ForwardMode
    @test ad.tag == CustomTag()
end

@testset "AutoModelingToolkit" begin
    ad = AutoModelingToolkit()
    @test ad isa AbstractADType
    @test ad isa AutoModelingToolkit
    @test mode(ad) isa SymbolicMode
    @test !ad.obj_sparse
    @test !ad.cons_sparse

    ad = AutoModelingToolkit(; obj_sparse = true, cons_sparse = true)
    @test ad isa AbstractADType
    @test ad isa AutoModelingToolkit
    @test mode(ad) isa SymbolicMode
    @test ad.obj_sparse
    @test ad.cons_sparse
end

@testset "AutoPolyesterForwardDiff" begin
    ad = AutoPolyesterForwardDiff()
    @test ad isa AbstractADType
    @test ad isa AutoPolyesterForwardDiff{nothing, Nothing}
    @test mode(ad) isa ForwardMode
    @test ad.tag === nothing

    ad = AutoPolyesterForwardDiff(; chunksize = 10, tag = CustomTag())
    @test ad isa AbstractADType
    @test ad isa AutoPolyesterForwardDiff{10, CustomTag}
    @test mode(ad) isa ForwardMode
    @test ad.tag == CustomTag()
end

@testset "AutoReverseDiff" begin
    ad = AutoReverseDiff()
    @test ad isa AbstractADType
    @test ad isa AutoReverseDiff
    @test mode(ad) isa ReverseMode
    @test !ad.compile

    ad = AutoReverseDiff(; compile = true)
    @test ad isa AbstractADType
    @test ad isa AutoReverseDiff
    @test mode(ad) isa ReverseMode
    @test ad.compile
end

@testset "AutoTapir" begin
    ad = AutoTapir()
    @test ad isa AbstractADType
    @test ad isa AutoTapir
    @test mode(ad) isa ReverseMode
end

@testset "AutoTracker" begin
    ad = AutoTracker()
    @test ad isa AbstractADType
    @test ad isa AutoTracker
    @test mode(ad) isa ReverseMode
end

@testset "AutoZygote" begin
    ad = AutoZygote()
    @test ad isa AbstractADType
    @test ad isa AutoZygote
    @test mode(ad) isa ReverseMode
end
