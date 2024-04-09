"""
    ADTypes.jl

[ADTypes.jl](https://github.com/SciML/ADTypes.jl) is a common system for implementing multi-valued logic for choosing which automatic differentiation library to use.
"""
module ADTypes

"""
Base type for AD choices.
"""
abstract type AbstractADType end

abstract type AbstractReverseMode <: AbstractADType end
abstract type AbstractForwardMode <: AbstractADType end
abstract type AbstractFiniteDifferencesMode <: AbstractADType end
abstract type AbstractSymbolicDifferentiationMode <: AbstractADType end

abstract type AbstractSparseReverseMode <: AbstractReverseMode end
abstract type AbstractSparseForwardMode <: AbstractForwardMode end
abstract type AbstractSparseFiniteDifferences <: AbstractFiniteDifferencesMode end
abstract type AbstractSparseSymbolicDifferentiationMode <:
              AbstractSymbolicDifferentiationMode end

## Dense

"""
    AutoChainRules{RC}

Chooses any AD library based on [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl), given an appropriate [`RuleConfig`](https://juliadiff.org/ChainRulesCore.jl/stable/rule_author/superpowers/ruleconfig.html) object.

# Fields

- `ruleconfig::RC`
"""
Base.@kwdef struct AutoChainRules{RC} <: AbstractADType
    ruleconfig::RC
end

"""
    AutoDiffractor

Chooses [Diffractor.jl](https://github.com/JuliaDiff/Diffractor.jl).
"""
struct AutoDiffractor <: AbstractADType end

"""
    AutoEnzyme{M}

Chooses [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl).

# Fields

- `mode::M = nothing`
"""
Base.@kwdef struct AutoEnzyme{M} <: AbstractADType
    mode::M = nothing
end

"""
    AutoFastDifferentiation

Chooses [FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl).
"""
struct AutoFastDifferentiation <: AbstractSymbolicDifferentiationMode end

"""
    AutoFiniteDiff{T1,T2,T3}

Chooses [FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl).

# Fields

- `fdtype::T1 = Val(:forward)`
- `fdjtype::T2 = fdtype`
- `fdhtype::T3 = Val(:hcentral)`
"""
Base.@kwdef struct AutoFiniteDiff{T1, T2, T3} <: AbstractFiniteDifferencesMode
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
end

"""
    AutoFiniteDifferences{T}

Chooses [FiniteDifferences.jl](https://github.com/JuliaDiff/FiniteDifferences.jl).

# Fields

- `fdm::T = nothing`
"""
Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractFiniteDifferencesMode
    fdm::T = nothing
end

"""
    AutoForwardDiff{chunksize,T}

Chooses [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl).

# Fields

- `tag::T`
"""
struct AutoForwardDiff{chunksize, T} <: AbstractForwardMode
    tag::T
end

"""
    AutoForwardDiff(; chunksize = nothing, tag = nothing)

Constructor.
"""
function AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize, typeof(tag)}(tag)
end

"""
    AutoModelingToolkit

Chooses [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).

# Fields

- `obj_sparse::Bool = false`
- `cons_sparse::Bool = false`
"""
Base.@kwdef struct AutoModelingToolkit <: AbstractSymbolicDifferentiationMode
    obj_sparse::Bool = false
    cons_sparse::Bool = false
end

"""
    AutoPolyesterForwardDiff{chunksize}

Chooses [PolyesterForwardDiff.jl](https://github.com/JuliaDiff/PolyesterForwardDiff.jl).
"""
struct AutoPolyesterForwardDiff{chunksize} <: AbstractForwardMode
end

"""
    AutoPolyesterForwardDiff(; chunksize = nothing)

Constructor.
"""
function AutoPolyesterForwardDiff(; chunksize = nothing)
    AutoPolyesterForwardDiff{chunksize}()
end

"""
    AutoReverseDiff

Chooses [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl).

# Fields

- `compile::Bool = false`
"""
Base.@kwdef struct AutoReverseDiff <: AbstractReverseMode
    compile::Bool = false
end

"""
    AutoTracker

Chooses [Tracker.jl](https://github.com/FluxML/Tracker.jl).
"""
struct AutoTracker <: AbstractReverseMode end

"""
    AutoZygote

Chooses [Zygote.jl](https://github.com/FluxML/Zygote.jl).
"""
struct AutoZygote <: AbstractReverseMode end

## Sparse

"""
    AutoSparseFiniteDiff{T1,T2,T3}

Chooses [FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl) while exploiting sparsity.

# Fields

- `fdtype::T1 = Val(:forward)`
- `fdjtype::T2 = fdtype`
- `fdhtype::T3 = Val(:hcentral)`
"""
Base.@kwdef struct AutoSparseFiniteDiff{T1, T2, T3, S} <: AbstractSparseFiniteDifferences
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
    sparsity_detector::S = nothing
end

"""
    AutoSparseForwardDiff{chunksize,T}

Chooses [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) while exploiting sparsity.

# Fields

- `tag::T`
"""
struct AutoSparseForwardDiff{chunksize, T, S} <: AbstractSparseForwardMode
    tag::T
    sparsity_detector::S = nothing
end

"""
    AutoSparseForwardDiff(; chunksize = nothing, tag = nothing)

Constructor.
"""
function AutoSparseForwardDiff(;
        chunksize = nothing, tag = nothing, sparsity_detector = nothing)
    AutoSparseForwardDiff{chunksize, typeof(tag), typeof(sparsity_detector)}(
        tag, sparsity_detector)
end

"""
    AutoSparsePolyesterForwardDiff{chunksize}

Chooses [PolyesterForwardDiff.jl](https://github.com/JuliaDiff/PolyesterForwardDiff.jl) while exploiting sparsity.
"""
struct AutoSparsePolyesterForwardDiff{chunksize, S} <: AbstractSparseForwardMode
    sparsity_detector::S
end

"""
    AutoSparsePolyesterForwardDiff(; chunksize = nothing)

Constructor.
"""
function AutoSparsePolyesterForwardDiff(; chunksize = nothing, sparsity_detector = nothing)
    AutoSparsePolyesterForwardDiff{chunksize, typeof(sparsity_detector)}(sparsity_detector)
end

"""
    AutoSparseReverseDiff

Chooses [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl) while exploiting sparsity.

# Fields

- `compile::Bool = false`
"""
Base.@kwdef struct AutoSparseReverseDiff{S} <: AbstractSparseReverseMode
    compile::Bool = false
    sparsity_detector::S
end

"""
    AutoSparseZygote

Chooses [Zygote.jl](https://github.com/FluxML/Zygote.jl) while exploiting sparsity.
"""
struct AutoSparseZygote{S} <: AbstractSparseReverseMode
    sparsity_detector::S
end

"""
    AutoSparseFastDifferentiation

Chooses [FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl) while exploiting sparsity.
"""
struct AutoSparseFastDifferentiation <: AbstractSparseSymbolicDifferentiationMode end

export AutoChainRules,
       AutoDiffractor,
       AutoFiniteDiff,
       AutoFiniteDifferences,
       AutoForwardDiff,
       AutoReverseDiff,
       AutoZygote,
       AutoEnzyme,
       AutoTracker,
       AutoModelingToolkit,
       AutoSparseFiniteDiff,
       AutoSparseForwardDiff,
       AutoSparseZygote,
       AutoSparseReverseDiff,
       AutoPolyesterForwardDiff,
       AutoSparsePolyesterForwardDiff,
       AutoFastDifferentiation,
       AutoSparseFastDifferentiation
end
