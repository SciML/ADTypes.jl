module ADTypesEnzymeCoreStructTypesExt

using ADTypes
using EnzymeCore
using StructTypes

# ── AutoEnzyme — mode serialized as a string, function_annotation dropped ────
#
# AutoEnzyme{M, A} has one runtime field (mode::M) and one type-level parameter
# (function_annotation::Type{A}).  The mode is an EnzymeCore mode instance; we
# serialize it as a short string ("Forward", "Reverse", or null) and reconstruct
# the matching EnzymeCore constant on reading.
#
# function_annotation is a Julia Type used internally to annotate Enzyme
# function arguments.  It cannot be meaningfully expressed in JSON and is not
# something a Python caller would set, so it is always reconstructed as Nothing.
#
# Supported mode strings and their corresponding EnzymeCore constants:
#   null        → nothing           (no mode; ADTypes picks a default at call time)
#   "Forward"   → EnzymeCore.Forward
#   "Reverse"   → EnzymeCore.Reverse

struct _AutoEnzymeRepr
    type::String
    mode::Union{String, Nothing}
end
StructTypes.StructType(::Type{_AutoEnzymeRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoEnzyme}) = StructTypes.CustomStruct()

function StructTypes.lower(x::ADTypes.AutoEnzyme)
    mode_str = if isnothing(x.mode)
        nothing
    elseif x.mode isa EnzymeCore.ForwardMode
        "Forward"
    elseif x.mode isa EnzymeCore.ReverseMode
        "Reverse"
    else
        error("Unsupported AutoEnzyme mode for JSON serialization: $(typeof(x.mode))")
    end
    return _AutoEnzymeRepr("AutoEnzyme", mode_str)
end

StructTypes.lowertype(::Type{<:ADTypes.AutoEnzyme}) = _AutoEnzymeRepr

function StructTypes.construct(::Type{<:ADTypes.AutoEnzyme}, x::_AutoEnzymeRepr)
    mode = if isnothing(x.mode)
        nothing
    elseif x.mode == "Forward"
        EnzymeCore.Forward
    elseif x.mode == "Reverse"
        EnzymeCore.Reverse
    else
        error("Unknown AutoEnzyme mode string: $(x.mode)")
    end
    return ADTypes.AutoEnzyme(; mode)
end

# ── AutoReactant — wraps an AutoEnzyme mode ───────────────────────────────────
#
# AutoReactant{M <: AutoEnzyme} holds an AutoEnzyme instance as its `mode`
# field.  We serialize `mode` through an AbstractADType-typed field so that
# AutoEnzyme's own CustomStruct lower embeds the nested "type" key correctly.

struct _AutoReactantRepr
    type::String
    mode::ADTypes.AbstractADType
end
StructTypes.StructType(::Type{_AutoReactantRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoReactant}) = StructTypes.CustomStruct()

StructTypes.lower(x::ADTypes.AutoReactant) = _AutoReactantRepr("AutoReactant", x.mode)

StructTypes.lowertype(::Type{<:ADTypes.AutoReactant}) = _AutoReactantRepr

function StructTypes.construct(::Type{<:ADTypes.AutoReactant}, x::_AutoReactantRepr)
    return ADTypes.AutoReactant(; mode = x.mode)
end

end # module ADTypesEnzymeCoreStructTypesExt
