using ADTypes
using ADTypes: AbstractADType
using ADTypes: AbstractFiniteDifferencesMode,
               AbstractForwardMode,
               AbstractReverseMode,
               AbstractSymbolicDifferentiationMode
using ADTypes: AbstractSparseFiniteDifferencesMode,
               AbstractSparseForwardMode,
               AbstractSparseReverseMode,
               AbstractSparseSymbolicDifferentiationMode
using ADTypes: dense_ad
using ADTypes: NoSparsityDetector,
               sparsity_detector,
               jacobian_sparsity,
               hessian_sparsity
using ADTypes: NoColoringAlgorithm,
               coloring_algorithm,
               column_coloring,
               row_coloring
using Test

function every_ad()
    return [
        AutoChainRules(:ruleconfig_placeholder),
        AutoDiffractor(),
        AutoEnzyme(),
        AutoFastDifferentiation(),
        AutoFiniteDiff(),
        AutoFiniteDifferences(),
        AutoForwardDiff(),
        AutoModelingToolkit(),
        AutoPolyesterForwardDiff(; chunksize = 10),
        AutoReverseDiff(),
        AutoTracker(),
        AutoZygote()
    ]
end

struct CustomTag end

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
