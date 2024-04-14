## Sparsity detector

"""
    AbstractSparsityDetector

Abstract supertype for sparsity pattern detectors, defined for instance in [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl).

# Required methods

- [`jacobian_sparsity`](@ref)
- [`hessian_sparsity`](@ref)
"""
abstract type AbstractSparsityDetector end

"""
    jacobian_sparsity(f, x, sd::AbstractSparsityDetector)::AbstractMatrix{Bool}
    jacobian_sparsity(f!, y, x, sd::AbstractSparsityDetector)::AbstractMatrix{Bool}

Use detector `sd` to construct a (typically sparse) matrix `S` describing the pattern of nonzeroes in the Jacobian of `f` (resp. `f!`) applied at `x` (resp. `(y, x)`).
"""
function jacobian_sparsity end

"""
    hessian_sparsity(f, x, sd::AbstractSparsityDetector)::AbstractMatrix{Bool}

Use detector `sd` to construct a (typically sparse) matrix `S` describing the pattern of nonzeroes in the Hessian of `f` applied at `x`.
"""
function hessian_sparsity end

"""
    NoSparsityDetector <: AbstractSparsityDetector

Trivial sparsity detector, which always returns a full sparsity pattern (only ones, no zeroes).

# See also

- [`AbstractSparsityDetector`](@ref)
"""
struct NoSparsityDetector <: AbstractSparsityDetector end

jacobian_sparsity(f, x, ::NoSparsityDetector) = ones(Bool, length(f(x)), length(x))
jacobian_sparsity(f!, y, x, ::NoSparsityDetector) = ones(Bool, length(y), length(x))
hessian_sparsity(f, x, ::NoSparsityDetector) = ones(Bool, length(x), length(x))

## Coloring algorithm

"""
    AbstractColoringAlgorithm

Abstract supertype for Jacobian/Hessian coloring algorithms, defined for example in [SparseDiffTools.jl](https://github.com/JuliaDiff/SparseDiffTools.jl).

# Required methods

- [`column_coloring`](@ref)
- [`row_coloring`](@ref)
"""
abstract type AbstractColoringAlgorithm end

"""
    column_coloring(M::AbstractMatrix, ca::ColoringAlgorithm)::AbstractVector{<:Integer}

Use algorithm `ca` to construct a coloring vector `c` of length `size(M, 2)` such that if two columns `j1` and `j2` satisfy `c[j1] = c[j2]`, they do not share any nonzero coefficients in `M`.
"""
function column_coloring end

"""
    row_coloring(M::AbstractMatrix, ca::ColoringAlgorithm)::AbstractVector{<:Integer}

Use algorithm `ca` to construct a coloring vector `c` of length `size(M, 1)` such that if two rows `i1` and `i2` satisfy `c[i1] = c[i2]`, they do not share any nonzero coefficients in `M`.
"""
function row_coloring end

"""
    NoColoringAlgorithm <: AbstractColoringAlgorithm

Trivial coloring algorithm, which always returns a different color for each matrix column/row.

# See also

- [`AbstractColoringAlgorithm`](@ref)
"""
struct NoColoringAlgorithm <: AbstractColoringAlgorithm end

column_coloring(M::AbstractMatrix, ::NoColoringAlgorithm) = 1:size(M, 2)
row_coloring(M::AbstractMatrix, ::NoColoringAlgorithm) = 1:size(M, 1)

## Sparse backend

"""
    AutoSparse{D,S,C}

Wraps an ADTypes.jl object to deal with sparse Jacobians and Hessians.

# Fields

- `dense_ad::D`: the underlying AD package, subtyping [`AbstractADType`](@ref)
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
    D <: AbstractADType,
    S <: AbstractSparsityDetector,
    C <: AbstractColoringAlgorithm
} <: AbstractADType
    dense_ad::D
    sparsity_detector::S
    coloring_algorithm::C
end

function AutoSparse(
        dense_ad;
        sparsity_detector = NoSparsityDetector(),
        coloring_algorithm = NoColoringAlgorithm())
    return AutoSparse{
        typeof(dense_ad),
        typeof(sparsity_detector),
        typeof(coloring_algorithm)
    }(dense_ad, sparsity_detector, coloring_algorithm)
end

"""
    dense_ad(ad::AutoSparse)::AbstractADType

Return the underlying AD package for a sparse AD choice.
    
# See also

- [`AutoSparse`](@ref)
"""
dense_ad(ad::AutoSparse) = ad.dense_ad

mode(sparse_ad::AutoSparse) = mode(dense_ad(sparse_ad))

"""
    sparsity_detector(ad::AutoSparse)::AbstractSparsityDetector

Return the sparsity pattern detector for a sparse AD choice.

# See also

- [`AutoSparse`](@ref)
- [`AbstractSparsityDetector`](@ref)
"""
sparsity_detector(ad::AutoSparse) = ad.sparsity_detector

"""
    coloring_algorithm(ad::AutoSparse)::AbstractColoringAlgorithm

Return the coloring algorithm for a sparse AD choice.

# See also

- [`AutoSparse`](@ref)
- [`AbstractColoringAlgorithm`](@ref)
"""
coloring_algorithm(ad::AutoSparse) = ad.coloring_algorithm
