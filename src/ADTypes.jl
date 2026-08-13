"""
    ADTypes.jl

[ADTypes.jl](https://github.com/SciML/ADTypes.jl) is a multi-valued logic system to choose an automatic differentiation (AD) package and specify its parameters.
"""
module ADTypes

using Base: @deprecate

"""
    AbstractADType

Abstract supertype for all AD choices.

# Extension contract

External packages may subtype `AbstractADType` to describe an AD backend. They must
also implement [`mode`](@ref) for their concrete subtype and return an instance of
an [`AbstractMode`](@ref) subtype. Consumers should dispatch on `mode(ad)`, rather
than on a downstream concrete AD type.
"""
abstract type AbstractADType end

Base.broadcastable(ad::AbstractADType) = Ref(ad)

@inline _unwrap_val(::Val{T}) where {T} = T
@inline _unwrap_val(x) = x

include("compat.jl") # @public macro
include("mode.jl")
include("dense.jl")
include("sparse.jl")
include("legacy.jl")
include("symbols.jl")

# Mutable registries used by ADTypesStructTypesExt and its companion extensions
# to make StructTypes.subtypes() dynamic.  Extensions add their own concrete
# subtypes during their __init__ callbacks so that JSON3 can read/write values
# typed as AbstractColoringAlgorithm or AbstractSparsityDetector regardless of
# which optional packages are loaded.
const _COLORING_ALGORITHM_TYPES = Dict{Symbol, Type}()
const _SPARSITY_DETECTOR_TYPES  = Dict{Symbol, Type}()

"""
    write_ad(ad::AbstractADType) -> String

Serialize an [`AbstractADType`](@ref) to a JSON string.

The output always contains a `"type"` key with the concrete type name, enabling
round-trip deserialization with [`read_ad`](@ref).

Requires `StructTypes` and `JSON3` to be loaded (via the `ADTypesJSON3Ext` extension).
"""
function write_ad end

"""
    read_ad(json::AbstractString) -> AbstractADType

Deserialize an [`AbstractADType`](@ref) from a JSON string produced by [`write_ad`](@ref).

Requires `StructTypes` and `JSON3` to be loaded (via the `ADTypesJSON3Ext` extension).
"""
function read_ad end

# Automatic Differentiation
export AbstractADType
export AutoChainRules,
    AutoDiffractor,
    AutoEnzyme,
    AutoFastDifferentiation,
    AutoFiniteDiff,
    AutoFiniteDifferences,
    AutoForwardDiff,
    AutoGTPSA,
    AutoHyperHessians,
    AutoModelingToolkit,
    AutoMooncake,
    AutoMooncakeForward,
    AutoPolyesterForwardDiff,
    AutoReverseDiff,
    AutoSymbolics,
    AutoTapir,
    AutoTaylorDiff,
    AutoTracker,
    AutoZygote,
    NoAutoDiff,
    NoAutoDiffSelectedError,
    AutoReactant
@public AbstractMode
@public ForwardMode, ReverseMode, ForwardOrReverseMode, SymbolicMode
@public mode
@public Auto
@public write_ad, read_ad

# Sparse Automatic Differentiation
export AutoSparse
@public dense_ad

# Sparsity detection
export AbstractSparsityDetector
export jacobian_sparsity, hessian_sparsity
@public sparsity_detector
@public NoSparsityDetector
@public KnownJacobianSparsityDetector
@public KnownHessianSparsityDetector

# Matrix coloring
export AbstractColoringAlgorithm
export column_coloring, row_coloring, symmetric_coloring
@public coloring_algorithm
@public NoColoringAlgorithm

# legacy exports are taken care of by @deprecated

end
