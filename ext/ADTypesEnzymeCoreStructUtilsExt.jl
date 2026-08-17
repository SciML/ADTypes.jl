module ADTypesEnzymeCoreStructUtilsExt

using ADTypes
using EnzymeCore
using StructUtils

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

function StructUtils.lower(x::ADTypes.AutoEnzyme)
    mode_str = if isnothing(x.mode)
        nothing
    elseif x.mode isa EnzymeCore.ForwardMode
        "Forward"
    elseif x.mode isa EnzymeCore.ReverseMode
        "Reverse"
    else
        error("Unsupported AutoEnzyme mode for JSON serialization: $(typeof(x.mode))")
    end
    return (type = "AutoEnzyme", mode = mode_str)
end

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoEnzyme}, source)
    mode_val = source["mode"][]
    mode = if isnothing(mode_val)
        nothing
    elseif mode_val == "Forward"
        EnzymeCore.Forward
    elseif mode_val == "Reverse"
        EnzymeCore.Reverse
    else
        error("Unknown AutoEnzyme mode string: $mode_val")
    end
    return ADTypes.AutoEnzyme(; mode), StructUtils.defaultstate(style)
end

# ── AutoReactant — wraps an AutoEnzyme mode ───────────────────────────────────
#
# AutoReactant{M <: AutoEnzyme} holds an AutoEnzyme instance as its `mode`
# field.  We lower `mode` as-is; when applyeach processes the NamedTuple,
# lower(style, mode_val) is called on the AutoEnzyme instance, which embeds
# the nested "type"/"mode" keys via AutoEnzyme's own lower method.

StructUtils.lower(x::ADTypes.AutoReactant) = (type = "AutoReactant", mode = x.mode)

function StructUtils.make(style::StructUtils.StructStyle, ::Type{<:ADTypes.AutoReactant}, source)
    mode = StructUtils.make(style, ADTypes.AutoEnzyme, source["mode"])[1]
    return ADTypes.AutoReactant(mode), StructUtils.defaultstate(style)
end

end # module ADTypesEnzymeCoreStructUtilsExt
