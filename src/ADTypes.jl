"""
    ADTypes.jl

[ADTypes.jl](https://github.com/SciML/ADTypes.jl) is a common system for implementing multi-valued logic for choosing which automatic differentiation library to use.
"""
module ADTypes

using Base: @deprecate

"""
    AbstractADType

Abstract supertype for all AD choices.
"""
abstract type AbstractADType end

Base.broadcastable(ad::AbstractADType) = Ref(ad)

include("mode.jl")
include("dense.jl")
include("sparse.jl")
include("legacy.jl")

if !isdefined(Base, :get_extension)
    include("../ext/ADTypesChainRulesCoreExt.jl")
    include("../ext/ADTypesEnzymeCoreExt.jl")
end

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
       AutoTapir,
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
