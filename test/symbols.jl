using ADTypes
using Test

@test ADTypes.Auto(:Diffractor) isa AutoDiffractor
@test ADTypes.Auto(:Enzyme) isa AutoEnzyme
@test ADTypes.Auto(:FastDifferentiation) isa AutoFastDifferentiation
@test ADTypes.Auto(:FiniteDiff) isa AutoFiniteDiff
@test ADTypes.Auto(:ForwardDiff) isa AutoForwardDiff
@test ADTypes.Auto(:PolyesterForwardDiff) isa AutoPolyesterForwardDiff
@test ADTypes.Auto(:ReverseDiff) isa AutoReverseDiff
@test ADTypes.Auto(:Symbolics) isa AutoSymbolics
@test ADTypes.Auto(:Tapir) isa AutoTapir
@test ADTypes.Auto(:Tracker) isa AutoTracker
@test ADTypes.Auto(:Zygote) isa AutoZygote

@test_throws ArgumentError ADTypes.Auto(:ChainRules)
@test_throws ArgumentError ADTypes.Auto(:FiniteDifferences)
