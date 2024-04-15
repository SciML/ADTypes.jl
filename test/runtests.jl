using ADTypes
using ADTypes: AbstractADType,
               mode,
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
using Aqua: Aqua
using ChainRulesCore: ChainRulesCore, RuleConfig,
                      HasForwardsMode, HasReverseMode,
                      NoForwardsMode, NoReverseMode
using EnzymeCore: EnzymeCore
using JET: JET
using Test

## Backend-specific

struct CustomTag end

struct ForwardRuleConfig <: RuleConfig{Union{HasForwardsMode, NoReverseMode}} end
struct ReverseRuleConfig <: RuleConfig{Union{NoForwardsMode, HasReverseMode}} end
struct ForwardOrReverseRuleConfig <: RuleConfig{Union{HasForwardsMode, HasReverseMode}} end

function every_ad()
    return [
        AutoChainRules(; ruleconfig = :rc),
        AutoDiffractor(),
        AutoEnzyme(),
        AutoFastDifferentiation(),
        AutoFiniteDiff(),
        AutoFiniteDifferences(; fdm = :fdm),
        AutoForwardDiff(),
        AutoPolyesterForwardDiff(),
        AutoReverseDiff(),
        AutoSymbolics(),
        AutoTapir(),
        AutoTracker(),
        AutoZygote()
    ]
end

## Tests

@testset verbose=true "ADTypes.jl" begin
    if VERSION >= v"1.7"
        @testset "Aqua.jl" begin
            Aqua.test_all(ADTypes; deps_compat = (check_extras = false,))
        end
        if VERSION < v"1.12"  # TODO: remove when JET works on nightly
            @testset "JET.jl" begin
                JET.test_package(ADTypes, target_defined_modules = true)
            end
        end
    end
    @testset "Dense" begin
        include("dense.jl")
    end
    @testset "Sparse" begin
        include("sparse.jl")
    end
    @testset "Legacy" begin
        include("legacy.jl")
    end
    @testset "Miscellaneous" begin
        include("misc.jl")
    end
end
