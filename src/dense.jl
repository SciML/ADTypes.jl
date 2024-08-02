"""
    AutoChainRules{RC}

Struct used to select an automatic differentiation backend based on [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl) (see the list [here](https://juliadiff.org/ChainRulesCore.jl/stable/index.html#ChainRules-roll-out-status)).

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoChainRules(; ruleconfig)

# Fields

  - `ruleconfig::RC`: a [`ChainRulesCore.RuleConfig`](https://juliadiff.org/ChainRulesCore.jl/stable/rule_author/superpowers/ruleconfig.html) object.
"""
Base.@kwdef struct AutoChainRules{RC} <: AbstractADType
    ruleconfig::RC
end

mode(::AutoChainRules) = ForwardOrReverseMode()  # specialized in the extension

function Base.show(io::IO, backend::AutoChainRules)
    print(io, AutoChainRules, "(ruleconfig=", repr(backend.ruleconfig; context = io), ")")
end

"""
    AutoDiffractor

Struct used to select the [Diffractor.jl](https://github.com/JuliaDiff/Diffractor.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoDiffractor()
"""
struct AutoDiffractor <: AbstractADType end

mode(::AutoDiffractor) = ForwardOrReverseMode()

"""
    AutoEnzyme{M,constant_function}

Struct used to select the [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoEnzyme(; mode=nothing, constant_function::Bool=false)

The `constant_function` keyword argument (and type parameter) determines whether the function object itself should be considered constant or not during differentiation with Enzyme.jl.
For simple functions, `constant_function` should usually be set to `true`, which leads to increased performance.
However, in the case of closures or callable structs which contain differentiated data, `constant_function` should be set to `false` to ensure correctness (more details below).

# Fields

  - `mode::M`: can be either

      + an object subtyping `EnzymeCore.Mode` (like `EnzymeCore.Forward` or `EnzymeCore.Reverse`) if a specific mode is required
      + `nothing` to choose the best mode automatically

# Notes

We now give several examples of functions.
For each one, we explain how `constant_function` should be set in order to compute the correct derivative with respect to the input `x`.

```julia
function f1(x)
    return x[1]
end
```

The function `f1` is not a closure, it does not contain any data.
Thus `f1` can be differentiated with `AutoEnzyme(constant_function=true)` (although here setting `constant_function=false` would change neither correctness nor performance).

```julia
parameter = [0.0]
function f2(x)
    return parameter[1] + x[1]
end
```

The function `f2` is a closure over `parameter`, but `parameter` is never modified based on the input `x`.
Thus, `f2` can be differentiated with `AutoEnzyme(constant_function=true)` (setting `constant_function=false` would not change correctness but would hinder performance).

```julia
cache = [0.0]
function f3(x)
    cache[1] = x[1]
    return cache[1] + x[1]
end
```

The function `f3` is a closure over `cache`, and `cache` is modified based on the input `x`.
That means `cache` cannot be treated as constant, since derivative values must be propagated through it.
Thus `f3` must be differentiated with `AutoEnzyme(constant_function=false)` (setting `constant_function=true` would make the result incorrect).
"""
struct AutoEnzyme{M, constant_function} <: AbstractADType
    mode::M
end

function AutoEnzyme(mode::M; constant_function::Bool = false) where {M}
    return AutoEnzyme{M, constant_function}(mode)
end

function AutoEnzyme(; mode::M = nothing, constant_function::Bool = false) where {M}
    return AutoEnzyme{M, constant_function}(mode)
end

mode(::AutoEnzyme) = ForwardOrReverseMode()  # specialized in the extension

function Base.show(io::IO, backend::AutoEnzyme)
    print(io, AutoEnzyme, "(")
    !isnothing(backend.mode) && print(io, "mode=", repr(backend.mode; context = io))
    print(io, ")")
end

"""
    AutoFastDifferentiation

Struct used to select the [FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoFastDifferentiation()
"""
struct AutoFastDifferentiation <: AbstractADType end

mode(::AutoFastDifferentiation) = SymbolicMode()

"""
    AutoFiniteDiff{T1,T2,T3}

Struct used to select the [FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoFiniteDiff(; fdtype=Val(:forward), fdjtype=fdtype, fdhtype=Val(:hcentral))

# Fields

  - `fdtype::T1`: finite difference type
  - `fdjtype::T2`: finite difference type for the Jacobian
  - `fdhtype::T3`: finite difference type for the Hessian
"""
Base.@kwdef struct AutoFiniteDiff{T1, T2, T3} <: AbstractADType
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
end

mode(::AutoFiniteDiff) = ForwardMode()

function Base.show(io::IO, backend::AutoFiniteDiff)
    print(io, AutoFiniteDiff, "(")
    backend.fdtype != Val(:forward) &&
        print(io, "fdtype=", repr(backend.fdtype; context = io), ", ")
    backend.fdjtype != backend.fdtype &&
        print(io, "fdjtype=", repr(backend.fdjtype; context = io), ", ")
    backend.fdhtype != Val(:hcentral) &&
        print(io, "fdhtype=", repr(backend.fdhtype; context = io))
    print(io, ")")
end

"""
    AutoFiniteDifferences{T}

Struct used to select the [FiniteDifferences.jl](https://github.com/JuliaDiff/FiniteDifferences.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoFiniteDifferences(; fdm)

# Fields

  - `fdm::T`: a [`FiniteDifferenceMethod`](https://juliadiff.org/FiniteDifferences.jl/stable/pages/api/#FiniteDifferences.FiniteDifferenceMethod)
"""
Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractADType
    fdm::T
end

mode(::AutoFiniteDifferences) = ForwardMode()

function Base.show(io::IO, backend::AutoFiniteDifferences)
    print(io, AutoFiniteDifferences, "(fdm=", repr(backend.fdm; context = io), ")")
end

"""
    AutoForwardDiff{chunksize,T}

Struct used to select the [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoForwardDiff(; chunksize=nothing, tag=nothing)

# Type parameters

  - `chunksize`: the preferred [chunk size](https://juliadiff.org/ForwardDiff.jl/stable/user/advanced/#Configuring-Chunk-Size) to evaluate several derivatives at once

# Fields

  - `tag::T`: a [custom tag](https://juliadiff.org/ForwardDiff.jl/release-0.10/user/advanced.html#Custom-tags-and-tag-checking-1) to handle nested differentiation calls (usually not necessary)
"""
struct AutoForwardDiff{chunksize, T} <: AbstractADType
    tag::T
end

function AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize, typeof(tag)}(tag)
end

mode(::AutoForwardDiff) = ForwardMode()

function Base.show(io::IO, backend::AutoForwardDiff{chunksize}) where {chunksize}
    print(io, AutoForwardDiff, "(")
    chunksize !== nothing && print(io, "chunksize=", repr(chunksize; context = io),
        (backend.tag !== nothing ? ", " : ""))
    backend.tag !== nothing && print(io, "tag=", repr(backend.tag; context = io))
    print(io, ")")
end

"""
    AutoPolyesterForwardDiff{chunksize,T}

Struct used to select the [PolyesterForwardDiff.jl](https://github.com/JuliaDiff/PolyesterForwardDiff.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoPolyesterForwardDiff(; chunksize=nothing, tag=nothing)

# Type parameters

  - `chunksize`: the preferred [chunk size](https://juliadiff.org/ForwardDiff.jl/stable/user/advanced/#Configuring-Chunk-Size) to evaluate several derivatives at once

# Fields

  - `tag::T`: a [custom tag](https://juliadiff.org/ForwardDiff.jl/release-0.10/user/advanced.html#Custom-tags-and-tag-checking-1) to handle nested differentiation calls (usually not necessary)
"""
struct AutoPolyesterForwardDiff{chunksize, T} <: AbstractADType
    tag::T
end

function AutoPolyesterForwardDiff(; chunksize = nothing, tag = nothing)
    AutoPolyesterForwardDiff{chunksize, typeof(tag)}(tag)
end

mode(::AutoPolyesterForwardDiff) = ForwardMode()

function Base.show(io::IO, backend::AutoPolyesterForwardDiff{chunksize}) where {chunksize}
    print(io, AutoPolyesterForwardDiff, "(")
    chunksize !== nothing && print(io, "chunksize=", repr(chunksize; context = io),
        (backend.tag !== nothing ? ", " : ""))
    backend.tag !== nothing && print(io, "tag=", repr(backend.tag; context = io))
    print(io, ")")
end

"""
    AutoReverseDiff{compile}

Struct used to select the [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoReverseDiff(; compile::Union{Val, Bool} = Val(false))

# Fields

  - `compile::Union{Val, Bool}`: whether to [compile the tape](https://juliadiff.org/ReverseDiff.jl/api/#ReverseDiff.compile) prior to differentiation (the boolean version is also the type parameter)
"""
struct AutoReverseDiff{C} <: AbstractADType
    compile::Bool  # this field is left for legacy reasons

    function AutoReverseDiff(; compile::Union{Val, Bool} = Val(false))
        _compile = _unwrap_val(compile)
        return new{_compile}(_compile)
    end
end

function Base.getproperty(ad::AutoReverseDiff, s::Symbol)
    if s === :compile
        Base.depwarn(
            "`ad.compile` where `ad` is `AutoReverseDiff` has been deprecated and will be removed in v2. Instead it is available as a compile-time constant as `AutoReverseDiff{true}` or `AutoReverseDiff{false}`.",
            :getproperty)
    end
    return getfield(ad, s)
end

mode(::AutoReverseDiff) = ReverseMode()

function Base.show(io::IO, ::AutoReverseDiff{compile}) where {compile}
    print(io, AutoReverseDiff, "(")
    compile && print(io, "compile=true")
    print(io, ")")
end

"""
    AutoSymbolics

Struct used to select the [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoSymbolics()
"""
struct AutoSymbolics <: AbstractADType end

mode(::AutoSymbolics) = SymbolicMode()

"""
    AutoTapir

Struct used to select the [Tapir.jl](https://github.com/withbayes/Tapir.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoTapir(; debug_mode::Bool)

# Fields

  - `safe_mode::Bool`: (to be renamed to `debug_mode` in the next breaking release)
    whether to run additional checks to catch errors early. While this is
    on by default to ensure that users are aware of this option, you should generally turn
    it off for actual use, as it has substantial performance implications.
    If you encounter a problem with using Tapir (it fails to differentiate a function, or
    something truly nasty like a segfault occurs), then you should try switching `safe_mode`
    on and look at what happens. Often errors are caught earlier and the error messages are
    more useful.
"""
struct AutoTapir <: AbstractADType
    safe_mode::Bool
end

# This is a really awkward function to deprecate, because Julia does not dispatch on kwargs.
function AutoTapir(;
    debug_mode::Union{Bool, Nothing}=nothing, safe_mode::Union{Bool, Nothing}=nothing
)
    if debug_mode !== nothing && safe_mode !== nothing
        throw(ArgumentError(
            "Both `debug_mode` and `safe_mode` have been set. Please only set `debug_mode`."
        ))
    end

    if safe_mode !== nothing
        Base.depwarn(
            "AutoTapir(; safe_mode) is deprecated, use AutoTapir(; debug_mode) instead.",
            ((Base.Core).Typeof(AutoTapir)).name.mt.name,
        )
        return AutoTapir(safe_mode)
    end

    if debug_mode === nothing
        Base.depwarn(
            "AutoTapir() is deprecated, use AutoTapir(; debug_mode=true) instead.",
            ((Base.Core).Typeof(AutoTapir)).name.mt.name,
        )
        return AutoTapir(true)
    else
        return AutoTapir(debug_mode)
    end
end

mode(::AutoTapir) = ReverseMode()

function Base.show(io::IO, backend::AutoTapir)
    print(io, AutoTapir, "(")
    !(backend.safe_mode) && print(io, "debug_mode=false")
    print(io, ")")
end

"""
    AutoTracker

Struct used to select the [Tracker.jl](https://github.com/FluxML/Tracker.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoTracker()
"""
struct AutoTracker <: AbstractADType end

mode(::AutoTracker) = ReverseMode()

"""
    AutoZygote

Struct used to select the [Zygote.jl](https://github.com/FluxML/Zygote.jl) backend for automatic differentiation.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).

# Constructors

    AutoZygote()
"""
struct AutoZygote <: AbstractADType end

mode(::AutoZygote) = ReverseMode()
