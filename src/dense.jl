"""
    AutoChainRules{RC}

Type used to select an automatic differentiation backend based on [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl) (see the list [here](https://juliadiff.org/ChainRulesCore.jl/stable/index.html#ChainRules-roll-out-status)).

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

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

Type indicating the use of the [Diffractor.jl](https://github.com/JuliaDiff/Diffractor.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructor

    AutoDiffractor()
"""
struct AutoDiffractor <: AbstractADType end

mode(::AutoDiffractor) = ForwardOrReverseMode()

"""
    AutoEnzyme{M}

Type indicating the use of the [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

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

Type indicating the use of the [FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructor

    AutoFastDifferentiation()
"""
struct AutoFastDifferentiation <: AbstractADType end

mode(::AutoFastDifferentiation) = SymbolicMode()

"""
    AutoFiniteDiff{T1,T2,T3}

Type indicating the use of the [FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

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

mode(::AutoFiniteDiff) = ForwardMode()

"""
    AutoFiniteDifferences{T}

Type indicating the use of the [FiniteDifferences.jl](https://github.com/JuliaDiff/FiniteDifferences.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Fields

- `fdm::T`: a [`FiniteDifferenceMethod`](https://juliadiff.org/FiniteDifferences.jl/stable/pages/api/#FiniteDifferences.FiniteDifferenceMethod)

# Constructor

    AutoFiniteDifferences(; fdm)
"""
Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractADType
    fdm::T
end

mode(::AutoFiniteDifferences) = ForwardMode()

"""
    AutoForwardDiff{chunksize,T}

Type indicating the use of the [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

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
    AutoPolyesterForwardDiff{chunksize,T}

Type indicating the use of the [PolyesterForwardDiff.jl](https://github.com/JuliaDiff/PolyesterForwardDiff.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

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

Type indicating the use of the [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

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
    AutoSymbolics

Type indicating the use of the [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructor

    AutoSymbolics()
"""
struct AutoSymbolics <: AbstractADType end

mode(::AutoSymbolics) = SymbolicMode()

"""
    AutoTapir

Type indicating the use of the [Tapir.jl](https://github.com/withbayes/Tapir.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructor

    AutoTapir()
"""
struct AutoTapir <: AbstractADType end

mode(::AutoTapir) = ReverseMode()

"""
    AutoTracker

Type indicating the use of the [Tracker.jl](https://github.com/FluxML/Tracker.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructor

    AutoTracker()
"""
struct AutoTracker <: AbstractADType end

mode(::AutoTracker) = ReverseMode()

"""
    AutoZygote

Type indicating the use of the [Zygote.jl](https://github.com/FluxML/Zygote.jl) backend for automatic differentiation.

Exported by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructor

    AutoZygote()
"""
struct AutoZygote <: AbstractADType end

mode(::AutoZygote) = ReverseMode()
