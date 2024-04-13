using ADTypes
using ADTypes: AbstractADType,
               mode,
               FiniteDifferencesMode,
               ForwardMode,
               ForwardOrReverseMode,
               ReverseMode,
               SymbolicMode
using ADTypes: dense_ad,
               NoSparsityDetector,
               sparsity_detector,
               jacobian_sparsity,
               hessian_sparsity,
               NoColoringAlgorithm,
               coloring_algorithm,
               column_coloring,
               row_coloring
using ChainRulesCore: ChainRulesCore, RuleConfig,
                      HasForwardsMode, HasReverseMode,
                      NoForwardsMode, NoReverseMode

using EnzymeCore: EnzymeCore
using Test

## Backend-specific

struct CustomTag end

struct ForwardRuleConfig <: RuleConfig{Union{HasForwardsMode, NoReverseMode}} end
struct ReverseRuleConfig <: RuleConfig{Union{NoForwardsMode, HasReverseMode}} end
struct ForwardOrReverseRuleConfig <: RuleConfig{Union{HasForwardsMode, HasReverseMode}} end

function every_ad()
    return [
        AutoChainRules(:rc),
        AutoDiffractor(),
        AutoEnzyme(),
        AutoFastDifferentiation(),
        AutoFiniteDiff(),
        AutoFiniteDifferences(:fdm),
        AutoForwardDiff(),
        AutoModelingToolkit(),
        AutoPolyesterForwardDiff(),
        AutoReverseDiff(),
        AutoTapir(),
        AutoTracker(),
        AutoZygote()
    ]
end

## Tests

@testset verbose=true "ADTypes.jl" begin
    @testset verbose=true "Dense" begin
        include("dense.jl")
    end
    @testset verbose=true "Sparse" begin
        include("sparse.jl")
    end
    @testset verbose=true "Legacy" begin
        include("legacy.jl")
    end
    @testset verbose=true "Miscellaneous" begin
        include("misc.jl")
    end
end
