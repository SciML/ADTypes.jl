@deprecate AutoSparseFastDifferentiation() AutoSparse(AutoFastDifferentiation())

@deprecate AutoSparseFiniteDiff(; kwargs...) AutoSparse(AutoFiniteDiff(; kwargs...))

@deprecate AutoSparseForwardDiff(; kwargs...) AutoSparse(AutoForwardDiff(; kwargs...))

@deprecate AutoSparsePolyesterForwardDiff(; kwargs...) AutoSparse(AutoPolyesterForwardDiff(;
    kwargs...))

@deprecate AutoSparseReverseDiff(; kwargs...) AutoSparse(AutoReverseDiff(; kwargs...))

@deprecate AutoSparseZygote() AutoSparse(AutoZygote())

function AutoModelingToolkit(sparse = false, cons_sparse = false; kwargs...)
    @warn "AutoModelingToolkit(args...) is deprecated, use AutoSymbolics() or AutoSparse(AutoSymbolics()) instead."  maxlog=1
    if sparse || cons_sparse
        return AutoSparse(AutoSymbolics())
    else
        return AutoSymbolics()
    end
end
