"""
    ADTypes.jl

[ADTypes.jl](https://github.com/SciML/ADTypes.jl) is a common system for implementing multi-valued logic for choosing which automatic differentiation library to use.
"""
module ADTypes

include("abstract.jl")
include("dense.jl")
include("sparse.jl")
include("legacy.jl")

export AbstractADType

export AutoChainRules,
       AutoDiffractor,
       AutoEnzyme,
       AutoFastDifferentiation,
       AutoFiniteDiff,
       AutoFiniteDifferences,
       AutoForwardDiff,
       AutoModelingToolkit,
       AutoPolyesterForwardDiff,
       AutoReverseDiff,
       AutoTracker,
       AutoZygote

export AutoSparse

# legacy

export AutoSparseFastDifferentiation,
       AutoSparseFiniteDiff,
       AutoSparseForwardDiff,
       AutoSparsePolyesterForwardDiff,
       AutoSparseReverseDiff,
       AutoSparseZygote

end
