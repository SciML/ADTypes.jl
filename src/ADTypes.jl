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

# Sparse Automatic Differentiation
export AutoSparse

# Sparsity detection
export AbstractSparsityDetector
export jacobian_sparsity, hessian_sparsity

# Matrix coloring
export AbstractColoringAlgorithm
export column_coloring, row_coloring, symmetric_coloring

# legacy exports are taken care of by @deprecated

# Define public interface
# To avoid a dependency on Compat.jl, this uses a trick suggested by Lilith Hafner:
# https://discourse.julialang.org/t/is-compat-jl-worth-it-for-the-public-keyword/119041/2
if VERSION >= v"1.11.0-DEV.469"
    # Automatic Differentiation
    eval(Meta.parse("public AbstractMode"))
    eval(Meta.parse("public ForwardMode, ReverseMode, ForwardOrReverseMode, SymbolicMode"))
    eval(Meta.parse("public mode"))
    eval(Meta.parse("public Auto"))

    # Sparse Automatic Differentiation
    eval(Meta.parse("public dense_ad"))

    # Sparsity detection
    eval(Meta.parse("public sparsity_detector"))
    eval(Meta.parse("public NoSparsityDetector"))
    eval(Meta.parse("public KnownJacobianSparsityDetector"))
    eval(Meta.parse("public KnownHessianSparsityDetector"))

    # Matrix coloring
    eval(Meta.parse("public NoColoringAlgorithm"))
    eval(Meta.parse("public coloring_algorithm"))
end

end
