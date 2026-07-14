@deprecate AutoSparseFastDifferentiation() AutoSparse(AutoFastDifferentiation())

@doc """
    AutoSparseFastDifferentiation()

!!! danger

    `AutoSparseFastDifferentiation` is deprecated, use
    `AutoSparse(AutoFastDifferentiation())` instead.

Deprecated constructor returning `AutoSparse(AutoFastDifferentiation())`.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
""" AutoSparseFastDifferentiation

@deprecate AutoSparseFiniteDiff(; kwargs...) AutoSparse(AutoFiniteDiff(; kwargs...))

@doc """
    AutoSparseFiniteDiff(; kwargs...)

!!! danger

    `AutoSparseFiniteDiff` is deprecated, use
    `AutoSparse(AutoFiniteDiff(; kwargs...))` instead.

Deprecated constructor returning `AutoSparse(AutoFiniteDiff(; kwargs...))`.
All keyword arguments are forwarded to [`AutoFiniteDiff`](@ref).

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
""" AutoSparseFiniteDiff

@deprecate AutoSparseForwardDiff(; kwargs...) AutoSparse(AutoForwardDiff(; kwargs...))

@doc """
    AutoSparseForwardDiff(; chunksize=nothing, tag=nothing)

!!! danger

    `AutoSparseForwardDiff` is deprecated, use
    `AutoSparse(AutoForwardDiff(; chunksize, tag))` instead.

Deprecated constructor returning `AutoSparse(AutoForwardDiff(; kwargs...))`.
All keyword arguments are forwarded to [`AutoForwardDiff`](@ref).

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
""" AutoSparseForwardDiff

@deprecate AutoSparsePolyesterForwardDiff(; kwargs...) AutoSparse(
    AutoPolyesterForwardDiff(;
        kwargs...
    )
)

@doc """
    AutoSparsePolyesterForwardDiff(; chunksize=nothing, tag=nothing)

!!! danger

    `AutoSparsePolyesterForwardDiff` is deprecated, use
    `AutoSparse(AutoPolyesterForwardDiff(; chunksize, tag))` instead.

Deprecated constructor returning `AutoSparse(AutoPolyesterForwardDiff(; kwargs...))`.
All keyword arguments are forwarded to [`AutoPolyesterForwardDiff`](@ref).

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
""" AutoSparsePolyesterForwardDiff

@deprecate AutoSparseReverseDiff(; kwargs...) AutoSparse(AutoReverseDiff(; kwargs...))

@deprecate AutoSparseReverseDiff(compile) AutoSparse(AutoReverseDiff(; compile))

@doc """
    AutoSparseReverseDiff(; compile::Union{Val, Bool}=Val(false))
    AutoSparseReverseDiff(compile)

!!! danger

    `AutoSparseReverseDiff` is deprecated, use
    `AutoSparse(AutoReverseDiff(; compile))` instead.

Deprecated constructor returning `AutoSparse(AutoReverseDiff(; compile))`.
The `compile` setting is forwarded to [`AutoReverseDiff`](@ref).

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
""" AutoSparseReverseDiff

@deprecate AutoSparseZygote() AutoSparse(AutoZygote())

@doc """
    AutoSparseZygote()

!!! danger

    `AutoSparseZygote` is deprecated, use `AutoSparse(AutoZygote())` instead.

Deprecated constructor returning `AutoSparse(AutoZygote())`.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
""" AutoSparseZygote

@deprecate AutoReverseDiff(compile) AutoReverseDiff(; compile)

function mtk_to_symbolics(obj_sparse::Bool, cons_sparse::Bool)
    if obj_sparse || cons_sparse
        return AutoSparse(AutoSymbolics())
    else
        return AutoSymbolics()
    end
end

"""
    AutoModelingToolkit(obj_sparse::Bool, cons_sparse::Bool)
    AutoModelingToolkit(; obj_sparse::Bool=false, cons_sparse::Bool=false)

!!! danger

    `AutoModelingToolkit` is deprecated, use [`AutoSymbolics`](@ref) or
    `AutoSparse(AutoSymbolics())` instead.

Deprecated symbolic automatic differentiation selector. It returns
`AutoSparse(AutoSymbolics())` when either sparsity flag is `true`, and
[`AutoSymbolics`](@ref) otherwise.

Defined by [ADTypes.jl](https://github.com/SciML/ADTypes.jl).
"""
function AutoModelingToolkit(obj_sparse::Bool, cons_sparse::Bool)
    Base.depwarn(
        "`AutoModelingToolkit(obj_sparse, cons_sparse)` is deprecated, use `AutoSymbolics()` or `AutoSparse(AutoSymbolics())` instead.",
        :AutoModelingToolkit; force = false
    )
    return mtk_to_symbolics(obj_sparse, cons_sparse)
end

function AutoModelingToolkit(; obj_sparse::Bool = false, cons_sparse::Bool = false)
    Base.depwarn(
        "`AutoModelingToolkit(; obj_sparse, cons_sparse)` is deprecated, use `AutoSymbolics()` or `AutoSparse(AutoSymbolics())` instead.",
        :AutoModelingToolkit; force = false
    )
    return mtk_to_symbolics(obj_sparse, cons_sparse)
end

function AutoTapir(; safe_mode = true)
    Base.depwarn(
        "`AutoTapir` is deprecated in favour of `AutoMooncake`.", :AutoTapir; force = false
    )
    return AutoTapir(safe_mode)
end
