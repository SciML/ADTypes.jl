module ADTypesStructUtilsExt

using ADTypes
using StructUtils

# ── Abstract supertype registrations ──────────────────────────────────────────
#
# @choosetype generates StructUtils.make overloads that read the "type"
# discriminator key from the JSON source and dispatch to the correct concrete
# type.  For AbstractColoringAlgorithm and AbstractSparsityDetector we use the
# mutable registries in ADTypes so that companion extensions (e.g.
# ADTypesSMCStructUtilsExt) can contribute their own types at runtime.
#
# The base concrete types are registered in __init__ below.

function __init__()
    ADTypes._COLORING_ALGORITHM_TYPES[:NoColoringAlgorithm] = ADTypes.NoColoringAlgorithm
    ADTypes._SPARSITY_DETECTOR_TYPES[:NoSparsityDetector] = ADTypes.NoSparsityDetector
    return nothing
end

StructUtils.@choosetype ADTypes.AbstractADType x -> begin
    type_str = x["type"][]
    if type_str == "AutoDiffractor"
        ADTypes.AutoDiffractor
    elseif type_str == "AutoFastDifferentiation"
        ADTypes.AutoFastDifferentiation
    elseif type_str == "AutoFiniteDiff"
        ADTypes.AutoFiniteDiff
    elseif type_str == "AutoForwardDiff"
        ADTypes.AutoForwardDiff
    elseif type_str == "AutoGTPSA"
        ADTypes.AutoGTPSA
    elseif type_str == "AutoHyperHessians"
        ADTypes.AutoHyperHessians
    elseif type_str == "AutoMooncake"
        ADTypes.AutoMooncake
    elseif type_str == "AutoMooncakeForward"
        ADTypes.AutoMooncakeForward
    elseif type_str == "AutoPolyesterForwardDiff"
        ADTypes.AutoPolyesterForwardDiff
    elseif type_str == "AutoReverseDiff"
        ADTypes.AutoReverseDiff
    elseif type_str == "AutoSymbolics"
        ADTypes.AutoSymbolics
    elseif type_str == "AutoTapir"
        ADTypes.AutoTapir
    elseif type_str == "AutoTaylorDiff"
        ADTypes.AutoTaylorDiff
    elseif type_str == "AutoTracker"
        ADTypes.AutoTracker
    elseif type_str == "AutoZygote"
        ADTypes.AutoZygote
    elseif type_str == "NoAutoDiff"
        ADTypes.NoAutoDiff
    elseif type_str == "AutoSparse"
        ADTypes.AutoSparse
    elseif type_str == "AutoEnzyme"
        ADTypes.AutoEnzyme
    elseif type_str == "AutoReactant"
        ADTypes.AutoReactant
    else
        throw(ArgumentError("Unknown ADType: $type_str"))
    end
end

StructUtils.@choosetype ADTypes.AbstractSparsityDetector x -> begin
    type_str = x["type"][]
    T = get(ADTypes._SPARSITY_DETECTOR_TYPES, Symbol(type_str), nothing)
    isnothing(T) && throw(ArgumentError("Unknown sparsity detector type: $type_str"))
    T
end

StructUtils.@choosetype ADTypes.AbstractColoringAlgorithm x -> begin
    type_str = x["type"][]
    T = get(ADTypes._COLORING_ALGORITHM_TYPES, Symbol(type_str), nothing)
    isnothing(T) && throw(ArgumentError("Unknown coloring algorithm type: $type_str"))
    T
end

# ── Serialization (lower) ──────────────────────────────────────────────────────
#
# StructUtils.lower(x) is called at the root of JSON serialization AND for each
# field value during applyeach traversal.  Returning a NamedTuple with "type"
# as the first key guarantees the discriminator always appears in the output.

# Fieldless / singleton concrete types
StructUtils.lower(::ADTypes.AutoDiffractor) = (type = "AutoDiffractor",)
StructUtils.lower(::ADTypes.AutoFastDifferentiation) = (type = "AutoFastDifferentiation",)
StructUtils.lower(::ADTypes.AutoSymbolics) = (type = "AutoSymbolics",)
StructUtils.lower(::ADTypes.AutoTracker) = (type = "AutoTracker",)
StructUtils.lower(::ADTypes.AutoZygote) = (type = "AutoZygote",)
StructUtils.lower(::ADTypes.NoAutoDiff) = (type = "NoAutoDiff",)
StructUtils.lower(::ADTypes.NoSparsityDetector) = (type = "NoSparsityDetector",)
StructUtils.lower(::ADTypes.NoColoringAlgorithm) = (type = "NoColoringAlgorithm",)

# ── AutoForwardDiff — chunksize in type parameter, tag dropped ────────────────
#
# The tag is runtime state managed by ForwardDiff to prevent confusion during
# nested differentiation; it is always reconstructed as nothing.

StructUtils.lower(::ADTypes.AutoForwardDiff{chunksize}) where {chunksize} =
    (type = "AutoForwardDiff", chunksize = chunksize)

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoForwardDiff}, source)
    chunksize = source["chunksize"][]
    return ADTypes.AutoForwardDiff{chunksize}(nothing), StructUtils.defaultstate(style)
end

# ── AutoReverseDiff — compile flag in type parameter ─────────────────────────
#
# The compile field has a deprecation on getproperty, so we extract the type
# parameter C directly rather than accessing the field.

StructUtils.lower(::ADTypes.AutoReverseDiff{C}) where {C} =
    (type = "AutoReverseDiff", compile = C)

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoReverseDiff}, source)
    compile = source["compile"][]
    return ADTypes.AutoReverseDiff(; compile = compile), StructUtils.defaultstate(style)
end

# ── AutoTaylorDiff — order in type parameter ──────────────────────────────────

StructUtils.lower(::ADTypes.AutoTaylorDiff{order}) where {order} =
    (type = "AutoTaylorDiff", order = order)

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoTaylorDiff}, source)
    order = source["order"][]
    return ADTypes.AutoTaylorDiff{order}(), StructUtils.defaultstate(style)
end

# ── AutoHyperHessians — chunksize in type parameter, simd/jet as fields ───────

function StructUtils.lower(x::ADTypes.AutoHyperHessians{chunksize}) where {chunksize}
    return (type = "AutoHyperHessians", chunksize = chunksize, simd = x.simd, jet = x.jet)
end

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoHyperHessians}, source)
    chunksize = source["chunksize"][]
    simd = source["simd"][]
    jet = source["jet"][]
    return ADTypes.AutoHyperHessians{chunksize}(simd, jet), StructUtils.defaultstate(style)
end

# ── AutoPolyesterForwardDiff — chunksize in type parameter, tag dropped ────────

StructUtils.lower(::ADTypes.AutoPolyesterForwardDiff{chunksize}) where {chunksize} =
    (type = "AutoPolyesterForwardDiff", chunksize = chunksize)

function StructUtils.make(
        style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoPolyesterForwardDiff}, source
    )
    chunksize = source["chunksize"][]
    return ADTypes.AutoPolyesterForwardDiff{chunksize}(nothing), StructUtils.defaultstate(style)
end

# ── AutoGTPSA — descriptor field: only nothing is serializable ────────────────

function StructUtils.lower(x::ADTypes.AutoGTPSA)
    isnothing(x.descriptor) ||
        error("AutoGTPSA with a non-nothing descriptor cannot be serialized to JSON")
    return (type = "AutoGTPSA",)
end

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoGTPSA}, source)
    return ADTypes.AutoGTPSA(), StructUtils.defaultstate(style)
end

# ── AutoMooncake — config field: only nothing is serializable ─────────────────

function StructUtils.lower(x::ADTypes.AutoMooncake)
    isnothing(x.config) ||
        error("AutoMooncake with a non-nothing config cannot be serialized to JSON")
    return (type = "AutoMooncake",)
end

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoMooncake}, source)
    return ADTypes.AutoMooncake(), StructUtils.defaultstate(style)
end

# ── AutoMooncakeForward — config field: only nothing is serializable ──────────

function StructUtils.lower(x::ADTypes.AutoMooncakeForward)
    isnothing(x.config) ||
        error("AutoMooncakeForward with a non-nothing config cannot be serialized to JSON")
    return (type = "AutoMooncakeForward",)
end

function StructUtils.make(
        style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoMooncakeForward}, source
    )
    return ADTypes.AutoMooncakeForward(), StructUtils.defaultstate(style)
end

# ── AutoTapir — safe_mode field (deprecated, use AutoMooncake instead) ────────
#
# AutoTapir is deprecated in favour of AutoMooncake.  The keyword constructor
# AutoTapir(; safe_mode=true) emits a deprecation warning, so we use the
# positional constructor AutoTapir(safe_mode) to suppress it during
# deserialization.

StructUtils.lower(x::ADTypes.AutoTapir) = (type = "AutoTapir", safe_mode = x.safe_mode)

function StructUtils.make(style::StructUtils.StructStyle, ::Type{ADTypes.AutoTapir}, source)
    safe_mode = source["safe_mode"][]
    return ADTypes.AutoTapir(safe_mode), StructUtils.defaultstate(style)  # positional: avoids depwarn
end

# ── AutoFiniteDiff — Val type parameters serialized as strings ────────────────
#
# fdtype, fdjtype, fdhtype are Val{Symbol} type parameters stored as fields.
# They are serialized as the symbol string ("forward", "hcentral", etc.) and
# reconstructed by wrapping back in Val(Symbol(...)).

function StructUtils.lower(x::ADTypes.AutoFiniteDiff)
    return (
        type = "AutoFiniteDiff",
        fdtype = String(_val_symbol(x.fdtype)),
        fdjtype = String(_val_symbol(x.fdjtype)),
        fdhtype = String(_val_symbol(x.fdhtype)),
        relstep = x.relstep === nothing ? nothing : Float64(x.relstep),
        absstep = x.absstep === nothing ? nothing : Float64(x.absstep),
        dir = x.dir isa Bool ? x.dir : Float64(x.dir),
    )
end

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoFiniteDiff}, source)
    fdtype = Val(Symbol(source["fdtype"][]))
    fdjtype = Val(Symbol(source["fdjtype"][]))
    fdhtype = Val(Symbol(source["fdhtype"][]))
    relstep = source["relstep"][]
    absstep = source["absstep"][]
    dir = source["dir"][]
    return ADTypes.AutoFiniteDiff(; fdtype, fdjtype, fdhtype, relstep, absstep, dir),
        StructUtils.defaultstate(style)
end

# Helper: extract the Symbol stored in a Val{s} type parameter.
_val_symbol(::Val{s}) where {s} = s

# ── AutoSparse ─────────────────────────────────────────────────────────────────
#
# The nested abstract-typed fields (dense_ad, sparsity_detector,
# coloring_algorithm) are included as-is in the lowered NamedTuple.  When
# applyeach processes this NamedTuple, lower() is called on each concrete field
# value, embedding the nested "type" keys via each type's own lower method.

function StructUtils.lower(x::ADTypes.AutoSparse)
    return (
        type = "AutoSparse",
        dense_ad = x.dense_ad,
        sparsity_detector = x.sparsity_detector,
        coloring_algorithm = x.coloring_algorithm,
    )
end

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoSparse}, source)
    dense_ad = StructUtils.make(style, ADTypes.AbstractADType, source["dense_ad"])[1]
    sparsity_detector = StructUtils.make(
        style, ADTypes.AbstractSparsityDetector, source["sparsity_detector"]
    )[1]
    coloring_algorithm = StructUtils.make(
        style, ADTypes.AbstractColoringAlgorithm, source["coloring_algorithm"]
    )[1]
    return ADTypes.AutoSparse(dense_ad; sparsity_detector, coloring_algorithm),
        StructUtils.defaultstate(style)
end

end # module ADTypesStructUtilsExt
