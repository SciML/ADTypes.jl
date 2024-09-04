"""
    ADTypes.jl

[ADTypes.jl](https://github.com/SciML/ADTypes.jl) is a multi-valued logic system to choose an automatic differentiation (AD) package and specify its parameters.
"""
module ADTypes

using Base: @deprecate
using Compat: @compat # for `public`

"""
    AbstractADType

Abstract supertype for all AD choices.
"""
abstract type AbstractADType end

Base.broadcastable(ad::AbstractADType) = Ref(ad)

@inline _unwrap_val(::Val{T}) where {T} = T
@inline _unwrap_val(x) = x

include("mode.jl")
include("dense.jl")
include("sparse.jl")
include("legacy.jl")
include("symbols.jl")

if !isdefined(Base, :get_extension)
    include("../ext/ADTypesChainRulesCoreExt.jl")
    include("../ext/ADTypesEnzymeCoreExt.jl")
end

# Automatic Differentiation
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
@compat public AbstractMode
@compat public ForwardMode, ReverseMode, ForwardOrReverseMode, SymbolicMode
@compat public mode
@compat public Auto

# Sparse Automatic Differentiation
export AutoSparse
@compat public dense_ad

# Sparsity detection
export AbstractSparsityDetector
export jacobian_sparsity, hessian_sparsity
@compat public sparsity_detector
@compat public NoSparsityDetector
@compat public KnownJacobianSparsityDetector, KnownHessianSparsityDetector

# Matrix coloring
export AbstractColoringAlgorithm
export column_coloring, row_coloring, symmetric_coloring
@compat public coloring_algorithm
@compat public NoColoringAlgorithm

# legacy exports are taken care of by @deprecated

end
