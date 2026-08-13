module ADTypesStructTypesExt

using ADTypes
using StructTypes

# ── Abstract supertype registrations ──────────────────────────────────────────
#
# These tell JSON3 which key to use as the type discriminator when reading
# through an abstract-typed field, and which concrete type to construct.
#
# StructType and subtypekey are defined exactly once here (in
# ADTypesStructTypesExt) for both AbstractColoringAlgorithm and
# AbstractSparsityDetector.  No companion extension ever redefines them, so
# there is no "method overwriting during precompilation" error.
#
# The concrete-subtype maps are held in two module-level Dicts in ADTypes:
#   ADTypes._COLORING_ALGORITHM_TYPES
#   ADTypes._SPARSITY_DETECTOR_TYPES
#
# Each extension that contributes additional concrete types adds its entries in
# its own __init__() callback:
#   ADTypesStructTypesExt     — NoColoringAlgorithm, NoSparsityDetector  (base)
#   ADTypesSMCStructTypesExt  — GreedyColoringAlgorithm
#   ADTypesSCTStructTypesExt  — TracerSparsityDetector, TracerLocalSparsityDetector
#   ADTypesDIStructTypesExt   — DenseSparsityDetector

function __init__()
    ADTypes._COLORING_ALGORITHM_TYPES[:NoColoringAlgorithm] = ADTypes.NoColoringAlgorithm
    ADTypes._SPARSITY_DETECTOR_TYPES[:NoSparsityDetector]   = ADTypes.NoSparsityDetector
end

StructTypes.StructType(::Type{ADTypes.AbstractColoringAlgorithm}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractColoringAlgorithm}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractColoringAlgorithm}) =
    NamedTuple(ADTypes._COLORING_ALGORITHM_TYPES)

StructTypes.StructType(::Type{ADTypes.AbstractSparsityDetector}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractSparsityDetector}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractSparsityDetector}) =
    NamedTuple(ADTypes._SPARSITY_DETECTOR_TYPES)

StructTypes.StructType(::Type{ADTypes.AbstractADType}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractADType}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractADType}) = (
    AutoDiffractor           = ADTypes.AutoDiffractor,
    AutoEnzyme               = ADTypes.AutoEnzyme,
    AutoFastDifferentiation  = ADTypes.AutoFastDifferentiation,
    AutoFiniteDiff           = ADTypes.AutoFiniteDiff,
    AutoForwardDiff          = ADTypes.AutoForwardDiff,
    AutoGTPSA                = ADTypes.AutoGTPSA,
    AutoHyperHessians        = ADTypes.AutoHyperHessians,
    AutoMooncake             = ADTypes.AutoMooncake,
    AutoMooncakeForward      = ADTypes.AutoMooncakeForward,
    AutoPolyesterForwardDiff = ADTypes.AutoPolyesterForwardDiff,
    AutoReactant             = ADTypes.AutoReactant,
    AutoReverseDiff          = ADTypes.AutoReverseDiff,
    AutoSymbolics            = ADTypes.AutoSymbolics,
    AutoTapir                = ADTypes.AutoTapir,
    AutoTaylorDiff           = ADTypes.AutoTaylorDiff,
    AutoTracker              = ADTypes.AutoTracker,
    AutoZygote               = ADTypes.AutoZygote,
    NoAutoDiff               = ADTypes.NoAutoDiff,
    AutoSparse               = ADTypes.AutoSparse,
)

# ── _TypedRepr — helper for fieldless types ───────────────────────────────────
#
# JSON3's write path dispatches on the *runtime* type of each value, not on
# the declared field type.  This means that a fieldless struct serialized with
# Struct() always produces "{}", with no "type" key, even when the value
# appears in an abstract-typed field.  To avoid this we use CustomStruct() for
# every fieldless concrete type, lowering to _TypedRepr which carries an
# explicit "type" string.

struct _TypedRepr
    type::String
end
StructTypes.StructType(::Type{_TypedRepr}) = StructTypes.Struct()

# ── Concrete types with no fields ─────────────────────────────────────────────

StructTypes.StructType(::Type{ADTypes.AutoDiffractor}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.AutoDiffractor) = _TypedRepr("AutoDiffractor")
StructTypes.lowertype(::Type{ADTypes.AutoDiffractor}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.AutoDiffractor}, ::_TypedRepr) = ADTypes.AutoDiffractor()

StructTypes.StructType(::Type{ADTypes.AutoFastDifferentiation}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.AutoFastDifferentiation) = _TypedRepr("AutoFastDifferentiation")
StructTypes.lowertype(::Type{ADTypes.AutoFastDifferentiation}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.AutoFastDifferentiation}, ::_TypedRepr) = ADTypes.AutoFastDifferentiation()

StructTypes.StructType(::Type{ADTypes.AutoSymbolics}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.AutoSymbolics) = _TypedRepr("AutoSymbolics")
StructTypes.lowertype(::Type{ADTypes.AutoSymbolics}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.AutoSymbolics}, ::_TypedRepr) = ADTypes.AutoSymbolics()

StructTypes.StructType(::Type{ADTypes.AutoTracker}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.AutoTracker) = _TypedRepr("AutoTracker")
StructTypes.lowertype(::Type{ADTypes.AutoTracker}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.AutoTracker}, ::_TypedRepr) = ADTypes.AutoTracker()

StructTypes.StructType(::Type{ADTypes.AutoZygote}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.AutoZygote) = _TypedRepr("AutoZygote")
StructTypes.lowertype(::Type{ADTypes.AutoZygote}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.AutoZygote}, ::_TypedRepr) = ADTypes.AutoZygote()

StructTypes.StructType(::Type{ADTypes.NoAutoDiff}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.NoAutoDiff) = _TypedRepr("NoAutoDiff")
StructTypes.lowertype(::Type{ADTypes.NoAutoDiff}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.NoAutoDiff}, ::_TypedRepr) = ADTypes.NoAutoDiff()

StructTypes.StructType(::Type{ADTypes.NoSparsityDetector}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.NoSparsityDetector) = _TypedRepr("NoSparsityDetector")
StructTypes.lowertype(::Type{ADTypes.NoSparsityDetector}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.NoSparsityDetector}, ::_TypedRepr) = ADTypes.NoSparsityDetector()

StructTypes.StructType(::Type{ADTypes.NoColoringAlgorithm}) = StructTypes.CustomStruct()
StructTypes.lower(::ADTypes.NoColoringAlgorithm) = _TypedRepr("NoColoringAlgorithm")
StructTypes.lowertype(::Type{ADTypes.NoColoringAlgorithm}) = _TypedRepr
StructTypes.construct(::Type{ADTypes.NoColoringAlgorithm}, ::_TypedRepr) = ADTypes.NoColoringAlgorithm()

# ── AutoForwardDiff — chunksize in type parameter, tag intentionally dropped ──
#
# AutoForwardDiff{chunksize, T} carries its chunk size as a type parameter and
# an optional tag as a field.  The tag is runtime state managed by ForwardDiff
# to prevent confusion during nested differentiation; it is not meaningful to a
# caller and is always reconstructed as `nothing`.  Only `chunksize` survives
# the round-trip.

struct _AutoForwardDiffRepr
    type::String
    chunksize::Union{Int, Nothing}
end
StructTypes.StructType(::Type{_AutoForwardDiffRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoForwardDiff}) = StructTypes.CustomStruct()

function StructTypes.lower(::ADTypes.AutoForwardDiff{chunksize}) where {chunksize}
    return _AutoForwardDiffRepr("AutoForwardDiff", chunksize)
end

StructTypes.lowertype(::Type{<:ADTypes.AutoForwardDiff}) = _AutoForwardDiffRepr

function StructTypes.construct(::Type{<:ADTypes.AutoForwardDiff}, x::_AutoForwardDiffRepr)
    return ADTypes.AutoForwardDiff{x.chunksize}(nothing)
end

# ── AutoReverseDiff — compile flag in both type parameter and field ────────────
#
# AutoReverseDiff{C} stores `compile` as type parameter C and as a Bool field.
# The two are always in sync (the inner constructor enforces this), so lowering
# to the field value and reconstructing via the keyword constructor is exact.

struct _AutoReverseDiffRepr
    type::String
    compile::Bool
end
StructTypes.StructType(::Type{_AutoReverseDiffRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoReverseDiff}) = StructTypes.CustomStruct()

StructTypes.lower(::ADTypes.AutoReverseDiff{C}) where {C} =
    _AutoReverseDiffRepr("AutoReverseDiff", C)

StructTypes.lowertype(::Type{<:ADTypes.AutoReverseDiff}) = _AutoReverseDiffRepr

function StructTypes.construct(::Type{<:ADTypes.AutoReverseDiff}, x::_AutoReverseDiffRepr)
    return ADTypes.AutoReverseDiff(; compile = x.compile)
end

# ── AutoSparse ─────────────────────────────────────────────────────────────────
#
# AutoSparse{D,S,C} is parameterized, so we lower it to _AutoSparseRepr.  The
# "type" field is included first so that the "type" key is always present in
# the emitted JSON.  The nested abstract-typed fields use the AbstractType()
# registrations above together with each concrete type's CustomStruct lower to
# embed their own "type" keys during serialization.

struct _AutoSparseRepr
    type::String
    dense_ad::ADTypes.AbstractADType
    sparsity_detector::ADTypes.AbstractSparsityDetector
    coloring_algorithm::ADTypes.AbstractColoringAlgorithm
end
StructTypes.StructType(::Type{_AutoSparseRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoSparse}) = StructTypes.CustomStruct()

StructTypes.lower(x::ADTypes.AutoSparse) =
    _AutoSparseRepr("AutoSparse", x.dense_ad, x.sparsity_detector, x.coloring_algorithm)

StructTypes.lowertype(::Type{<:ADTypes.AutoSparse}) = _AutoSparseRepr

function StructTypes.construct(::Type{<:ADTypes.AutoSparse}, x::_AutoSparseRepr)
    return ADTypes.AutoSparse(
        x.dense_ad;
        sparsity_detector  = x.sparsity_detector,
        coloring_algorithm = x.coloring_algorithm,
    )
end

# ── AutoTaylorDiff — order in type parameter ──────────────────────────────────

struct _AutoTaylorDiffRepr
    type::String
    order::Int
end
StructTypes.StructType(::Type{_AutoTaylorDiffRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoTaylorDiff}) = StructTypes.CustomStruct()

StructTypes.lower(::ADTypes.AutoTaylorDiff{order}) where {order} =
    _AutoTaylorDiffRepr("AutoTaylorDiff", order)

StructTypes.lowertype(::Type{<:ADTypes.AutoTaylorDiff}) = _AutoTaylorDiffRepr

function StructTypes.construct(::Type{<:ADTypes.AutoTaylorDiff}, x::_AutoTaylorDiffRepr)
    return ADTypes.AutoTaylorDiff{x.order}()
end

# ── AutoHyperHessians — chunksize in type parameter, simd and jet as fields ───

struct _AutoHyperHessiansRepr
    type::String
    chunksize::Union{Int, Nothing}
    simd::Bool
    jet::Bool
end
StructTypes.StructType(::Type{_AutoHyperHessiansRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoHyperHessians}) = StructTypes.CustomStruct()

function StructTypes.lower(x::ADTypes.AutoHyperHessians{chunksize}) where {chunksize}
    return _AutoHyperHessiansRepr("AutoHyperHessians", chunksize, x.simd, x.jet)
end

StructTypes.lowertype(::Type{<:ADTypes.AutoHyperHessians}) = _AutoHyperHessiansRepr

function StructTypes.construct(::Type{<:ADTypes.AutoHyperHessians}, x::_AutoHyperHessiansRepr)
    return ADTypes.AutoHyperHessians{x.chunksize}(x.simd, x.jet)
end

# ── AutoPolyesterForwardDiff — chunksize in type parameter, tag dropped ────────
#
# Like AutoForwardDiff, the tag is runtime state managed by the differentiation
# library to prevent confusion during nested differentiation.  It is always
# reconstructed as `nothing`.

struct _AutoPolyesterForwardDiffRepr
    type::String
    chunksize::Union{Int, Nothing}
end
StructTypes.StructType(::Type{_AutoPolyesterForwardDiffRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoPolyesterForwardDiff}) = StructTypes.CustomStruct()

StructTypes.lower(::ADTypes.AutoPolyesterForwardDiff{chunksize}) where {chunksize} =
    _AutoPolyesterForwardDiffRepr("AutoPolyesterForwardDiff", chunksize)

StructTypes.lowertype(::Type{<:ADTypes.AutoPolyesterForwardDiff}) = _AutoPolyesterForwardDiffRepr

function StructTypes.construct(::Type{<:ADTypes.AutoPolyesterForwardDiff}, x::_AutoPolyesterForwardDiffRepr)
    return ADTypes.AutoPolyesterForwardDiff{x.chunksize}(nothing)
end

# ── AutoGTPSA — descriptor field, only nothing is serializable ────────────────
#
# AutoGTPSA{D} carries an optional GTPSA descriptor.  A GTPSA descriptor is a
# runtime object that cannot be expressed in JSON, so only the default
# (descriptor = nothing) is supported.

StructTypes.StructType(::Type{<:ADTypes.AutoGTPSA}) = StructTypes.CustomStruct()

function StructTypes.lower(x::ADTypes.AutoGTPSA)
    isnothing(x.descriptor) ||
        error("AutoGTPSA with a non-nothing descriptor cannot be serialized to JSON")
    return _TypedRepr("AutoGTPSA")
end

StructTypes.lowertype(::Type{<:ADTypes.AutoGTPSA}) = _TypedRepr

StructTypes.construct(::Type{<:ADTypes.AutoGTPSA}, ::_TypedRepr) = ADTypes.AutoGTPSA()

# ── AutoMooncake — config field, only nothing is serializable ─────────────────
#
# AutoMooncake{Tconfig} carries an optional Mooncake config.  A Mooncake config
# is a runtime object that cannot be expressed in JSON, so only the default
# (config = nothing) is supported.

StructTypes.StructType(::Type{<:ADTypes.AutoMooncake}) = StructTypes.CustomStruct()

function StructTypes.lower(x::ADTypes.AutoMooncake)
    isnothing(x.config) ||
        error("AutoMooncake with a non-nothing config cannot be serialized to JSON")
    return _TypedRepr("AutoMooncake")
end

StructTypes.lowertype(::Type{<:ADTypes.AutoMooncake}) = _TypedRepr

StructTypes.construct(::Type{<:ADTypes.AutoMooncake}, ::_TypedRepr) = ADTypes.AutoMooncake()

# ── AutoMooncakeForward — config field, only nothing is serializable ──────────

StructTypes.StructType(::Type{<:ADTypes.AutoMooncakeForward}) = StructTypes.CustomStruct()

function StructTypes.lower(x::ADTypes.AutoMooncakeForward)
    isnothing(x.config) ||
        error("AutoMooncakeForward with a non-nothing config cannot be serialized to JSON")
    return _TypedRepr("AutoMooncakeForward")
end

StructTypes.lowertype(::Type{<:ADTypes.AutoMooncakeForward}) = _TypedRepr

StructTypes.construct(::Type{<:ADTypes.AutoMooncakeForward}, ::_TypedRepr) =
    ADTypes.AutoMooncakeForward()

# ── AutoTapir — safe_mode field (deprecated, use AutoMooncake instead) ────────
#
# AutoTapir is deprecated in favour of AutoMooncake.  The keyword constructor
# AutoTapir(; safe_mode=true) emits a deprecation warning, so we use the
# positional constructor AutoTapir(safe_mode) to suppress it during
# deserialization.

struct _AutoTapirRepr
    type::String
    safe_mode::Bool
end
StructTypes.StructType(::Type{_AutoTapirRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{ADTypes.AutoTapir}) = StructTypes.CustomStruct()

StructTypes.lower(x::ADTypes.AutoTapir) = _AutoTapirRepr("AutoTapir", x.safe_mode)

StructTypes.lowertype(::Type{ADTypes.AutoTapir}) = _AutoTapirRepr

function StructTypes.construct(::Type{ADTypes.AutoTapir}, x::_AutoTapirRepr)
    return ADTypes.AutoTapir(x.safe_mode)   # positional: avoids deprecation warning
end

# ── AutoFiniteDiff — Val type parameters serialized as strings ─────────────────
#
# AutoFiniteDiff{T1,T2,T3,S1,S2,S3} stores its finite-difference type tags
# (fdtype, fdjtype, fdhtype) as Val{Symbol} type parameters and its step sizes
# (relstep, absstep) as optional Float64 fields.  The direction `dir` defaults
# to true (Bool) but may also be a Float64 (e.g. 1.0 or -1.0).
#
# Val{:forward} is serialized as the string "forward", Val{:hcentral} as
# "hcentral", and so on.  Reconstruction wraps each string back in Val(Symbol()).

struct _AutoFiniteDiffRepr
    type::String
    fdtype::String
    fdjtype::String
    fdhtype::String
    relstep::Union{Float64, Nothing}
    absstep::Union{Float64, Nothing}
    dir::Union{Bool, Float64}
end
StructTypes.StructType(::Type{_AutoFiniteDiffRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoFiniteDiff}) = StructTypes.CustomStruct()

function StructTypes.lower(x::ADTypes.AutoFiniteDiff)
    return _AutoFiniteDiffRepr(
        "AutoFiniteDiff",
        String(_val_symbol(x.fdtype)),
        String(_val_symbol(x.fdjtype)),
        String(_val_symbol(x.fdhtype)),
        x.relstep === nothing ? nothing : Float64(x.relstep),
        x.absstep === nothing ? nothing : Float64(x.absstep),
        x.dir isa Bool ? x.dir : Float64(x.dir),
    )
end

StructTypes.lowertype(::Type{<:ADTypes.AutoFiniteDiff}) = _AutoFiniteDiffRepr

function StructTypes.construct(::Type{<:ADTypes.AutoFiniteDiff}, x::_AutoFiniteDiffRepr)
    return ADTypes.AutoFiniteDiff(
        fdtype  = Val(Symbol(x.fdtype)),
        fdjtype = Val(Symbol(x.fdjtype)),
        fdhtype = Val(Symbol(x.fdhtype)),
        relstep = x.relstep,
        absstep = x.absstep,
        dir     = x.dir,
    )
end

# Helper: extract the Symbol stored in a Val{s} type parameter.
_val_symbol(::Val{s}) where {s} = s

end # module ADTypesStructTypesExt
