"""
    AutoChainRules{RC}

Chooses any AD library based on [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl) (see the list [here](https://juliadiff.org/ChainRulesCore.jl/stable/index.html#ChainRules-roll-out-status)).

# Fields

- `ruleconfig::RC`: a [`ChainRulesCore.RuleConfig`](https://juliadiff.org/ChainRulesCore.jl/stable/rule_author/superpowers/ruleconfig.html) object.

# Constructor

    AutoChainRules(; ruleconfig)
"""
Base.@kwdef struct AutoChainRules{RC} <: AbstractADType
    ruleconfig::RC
end

mode(::AutoChainRules) = ForwardOrReverseMode()  # specialized in the extension

"""
    AutoDiffractor

Chooses [Diffractor.jl](https://github.com/JuliaDiff/Diffractor.jl).

# Constructor

    AutoDiffractor()
"""
struct AutoDiffractor <: AbstractADType end

mode(::AutoDiffractor) = ForwardOrReverseMode()

"""
    AutoEnzyme{M}

Chooses [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl).

# Fields

- `mode::M`: can be either 
  - an object subtyping `EnzymeCore.Mode` (like `EnzymeCore.Forward` or `EnzymeCore.Reverse`) if a specific mode is required
  - `nothing` to choose the best mode automatically

# Constructors

    AutoEnzyme(; mode=nothing)
"""
Base.@kwdef struct AutoEnzyme{M} <: AbstractADType
    mode::M = nothing
end

mode(::AutoEnzyme) = ForwardOrReverseMode()  # specialized in the extension

"""
    AutoFastDifferentiation

Chooses [FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl).

# Constructor

    AutoFastDifferentiation()
"""
struct AutoFastDifferentiation <: AbstractADType end

mode(::AutoFastDifferentiation) = SymbolicMode()

"""
    AutoFiniteDiff{T1,T2,T3}

Chooses [FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl).

# Fields

- `fdtype::T1`: finite difference type
- `fdjtype::T2`: finite difference type for the Jacobian
- `fdhtype::T3`: finite difference type for the Hessian

# Constructor

    AutoFiniteDiff(; fdtype=Val(:forward), fdjtype=fdtype, fdhtype=Val(:hcentral))
"""
Base.@kwdef struct AutoFiniteDiff{T1, T2, T3} <: AbstractADType
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
end

mode(::AutoFiniteDiff) = FiniteDifferencesMode()

"""
    AutoFiniteDifferences{T}

Chooses [FiniteDifferences.jl](https://github.com/JuliaDiff/FiniteDifferences.jl).

# Fields

- `fdm::T`: a [`FiniteDifferenceMethod`](https://juliadiff.org/FiniteDifferences.jl/stable/pages/api/#FiniteDifferences.FiniteDifferenceMethod), constructed for instance with `FiniteDifferences.central_fdm`. 

# Constructor

    AutoFiniteDifferences(; fdm)
"""
Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractADType
    fdm::T
end

mode(::AutoFiniteDifferences) = FiniteDifferencesMode()

"""
    AutoForwardDiff{chunksize,T}

Chooses [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl).

# Type parameters

- `chunksize`: the preferred [chunk size](https://juliadiff.org/ForwardDiff.jl/stable/user/advanced/#Configuring-Chunk-Size) to evaluate several derivatives at once

# Fields

- `tag::T`: a [custom tag](https://juliadiff.org/ForwardDiff.jl/release-0.10/user/advanced.html#Custom-tags-and-tag-checking-1) to handle nested differentiation calls (usually not necessary)

# Constructors

    AutoForwardDiff(; chunksize=nothing, tag=nothing)
"""
struct AutoForwardDiff{chunksize, T} <: AbstractADType
    tag::T
end

function AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize, typeof(tag)}(tag)
end

mode(::AutoForwardDiff) = ForwardMode()

"""
    AutoModelingToolkit

Chooses [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).

# Fields

- `obj_sparse::Bool`
- `cons_sparse::Bool`

# Constructor

    AutoModelingToolkit(; obj_sparse=false, cons_sparse=false)
"""
Base.@kwdef struct AutoModelingToolkit <: AbstractADType
    obj_sparse::Bool = false
    cons_sparse::Bool = false
end

mode(::AutoModelingToolkit) = SymbolicMode()

"""
    AutoPolyesterForwardDiff{chunksize,T}

Chooses [PolyesterForwardDiff.jl](https://github.com/JuliaDiff/PolyesterForwardDiff.jl).

# Type parameters

- `chunksize`: the preferred [chunk size](https://juliadiff.org/ForwardDiff.jl/stable/user/advanced/#Configuring-Chunk-Size) to evaluate several derivatives at once

# Fields

- `tag::T`: a [custom tag](https://juliadiff.org/ForwardDiff.jl/release-0.10/user/advanced.html#Custom-tags-and-tag-checking-1) to handle nested differentiation calls (usually not necessary)

# Constructors

    AutoPolyesterForwardDiff(; chunksize=nothing, tag=nothing)
"""
struct AutoPolyesterForwardDiff{chunksize, T} <: AbstractADType
    tag::T
end

function AutoPolyesterForwardDiff(; chunksize = nothing, tag = nothing)
    AutoPolyesterForwardDiff{chunksize, typeof(tag)}(tag)
end

mode(::AutoPolyesterForwardDiff) = ForwardMode()

"""
    AutoReverseDiff

Chooses [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl).

# Fields

- `compile::Bool`: whether to [compile the tape](https://juliadiff.org/ReverseDiff.jl/api/#ReverseDiff.compile) prior to differentiation

# Constructor

    AutoReverseDiff(; compile=false)
"""
Base.@kwdef struct AutoReverseDiff <: AbstractADType
    compile::Bool = false
end

mode(::AutoReverseDiff) = ReverseMode()

"""
    AutoTapir

Chooses [Tapir.jl](https://github.com/withbayes/Tapir.jl).

!!! danger
    This package is experimental, use at your own risk.

# Constructor

    AutoTapir()
"""
struct AutoTapir <: AbstractADType end

mode(::AutoTapir) = ReverseMode()

"""
    AutoTracker

Chooses [Tracker.jl](https://github.com/FluxML/Tracker.jl).

# Constructor

    AutoTracker()
"""
struct AutoTracker <: AbstractADType end

mode(::AutoTracker) = ReverseMode()

"""
    AutoZygote

Chooses [Zygote.jl](https://github.com/FluxML/Zygote.jl).

# Constructor

    AutoZygote()
"""
struct AutoZygote <: AbstractADType end

mode(::AutoZygote) = ReverseMode()
