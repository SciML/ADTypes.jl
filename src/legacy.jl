@deprecate AutoSparseFastDifferentiation() AutoSparse(AutoFastDifferentiation())

@deprecate AutoSparseFiniteDiff(; kwargs...) AutoSparse(AutoFiniteDiff(; kwargs...))

@deprecate AutoSparseForwardDiff(; kwargs...) AutoSparse(AutoForwardDiff(; kwargs...))

@deprecate AutoSparsePolyesterForwardDiff(; kwargs...) AutoSparse(AutoPolyesterForwardDiff(;
    kwargs...))

@deprecate AutoSparseReverseDiff(; kwargs...) AutoSparse(AutoReverseDiff(; kwargs...))

@deprecate AutoSparseZygote(; kwargs...) AutoSparse(AutoZygote(; kwargs...))
