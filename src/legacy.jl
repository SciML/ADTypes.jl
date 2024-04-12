AutoSparseFastDifferentiation() = AutoSparse(AutoFastDifferentiation())

AutoSparseFiniteDiff(; kwargs...) = AutoSparse(AutoFiniteDiff(; kwargs...))

AutoSparseForwardDiff(; kwargs...) = AutoSparse(AutoForwardDiff(; kwargs...))

function AutoSparsePolyesterForwardDiff(; kwargs...)
    AutoSparse(AutoPolyesterForwardDiff(; kwargs...))
end

AutoSparseReverseDiff(; kwargs...) = AutoSparse(AutoReverseDiff(; kwargs...))

AutoSparseZygote(; kwargs...) = AutoSparse(AutoZygote(; kwargs...))
