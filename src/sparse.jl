"""
    AbstractSparsityDetector

Abstract supertype for sparsity pattern detectors, defined for instance in [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl).
"""
abstract type AbstractSparsityDetector end

"""
    NoSparsityDetector <: AbstractSparsityDetector

Trivial sparsity detector, which always returns a full sparsity pattern (only ones, no zeroes).
"""
struct NoSparsityDetector <: AbstractSparsityDetector end

"""
    AbstractColoringAlgorithm

Abstract supertype for Jacobian/Hessian coloring algorithms, defined for example in [SparseDiffTools.jl](https://github.com/JuliaDiff/SparseDiffTools.jl).
"""
abstract type AbstractColoringAlgorithm end

"""
    NoColoringAlgorithm <: AbstractColoringAlgorithm

Trivial coloring algorithm, which always returns a different color for each matrix column/row.
"""
struct NoColoringAlgorithm <: AbstractColoringAlgorithm end

"""
    AutoSparse{mode,D,S,C}

Wraps an ADTypes.jl object to deal with sparse Jacobians and Hessians.

# Fields

- `dense_ad::D`: the underlying choice of AD package, subtyping [`AbstractADType`](@ref)
- `sparsity_detector::S`: the sparsity pattern detector, subtyping [`AbstractSparsityDetector`](@ref)
- `coloring_algorithm::C`: the coloring algorithm, subtyping [`AbstractColoringAlgorithm`](@ref)

# Constructors

    AutoSparse(
        dense_ad;
        sparsity_detector=ADTypes.NoSparsityDetector(),
        coloring_algorithm=ADTypes.NoColoringAlgorithm()
    )
"""
struct AutoSparse{
    mode, D <: AbstractADType{mode}, S <: AbstractSparsityDetector,
    C <: AbstractColoringAlgorithm} <:
       AbstractADType{mode}
    dense_ad::D
    sparsity_detector::S
    coloring_algorithm::C
end

function AutoSparse(
        dense_ad::AbstractADType{mode}; sparsity_detector = NoSparsityDetector(),
        coloring_algorithm = NoColoringAlgorithm()) where {mode}
    return AutoSparse{
        mode, typeof(dense_ad), typeof(sparsity_detector), typeof(coloring_algorithm)}(
        dense_ad, sparsity_detector, coloring_algorithm)
end

"""
    dense_ad(ad::AutoSparse)
"""
dense_ad(ad::AutoSparse) = ad.dense_ad

"""
    sparsity_detector(ad::AutoSparse)
"""
sparsity_detector(ad::AutoSparse) = ad.sparsity_detector

"""
    coloring_algorithm(ad::AutoSparse)
"""
coloring_algorithm(ad::AutoSparse) = ad.coloring_algorithm

const AbstractSparseFiniteDifferencesMode = AutoSparse{:finite}
const AbstractSparseForwardMode = AutoSparse{:forward}
const AbstractSparseReverseMode = AutoSparse{:reverse}
const AbstractSparseSymbolicDifferentiationMode = AutoSparse{:symbolic}
