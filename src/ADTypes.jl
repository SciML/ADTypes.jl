"""
    ADTypes.jl

[ADTypes.jl](https://github.com/SciML/ADTypes.jl) is a multi-valued logic system to choose an automatic differentiation (AD) package and specify its parameters.
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
include("symbols.jl")

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
       AutoSymbolics,
       AutoTapir,
       AutoTracker,
       AutoZygote

export AutoSparse

# legacy exports are taken care of by @deprecated

end
