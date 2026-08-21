module ADTypesEnzymeCoreJSONExt

using ADTypes
using EnzymeCore
using JSON
using StructUtils

# ── JSON-specific make methods ────────────────────────────────────────────────
#
# Specialize on JSON.JSONStyle so these methods win over the generic
# StructUtils.StructStyle versions in ADTypesEnzymeCoreStructUtilsExt.
# JSON.skip(source) returns the end position of the JSON object, satisfying
# JSON._parse's checkendpos requirement.

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoEnzyme}, source)
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
    return ADTypes.AutoEnzyme(; mode), JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoReactant}, source)
    mode = StructUtils.make(style, ADTypes.AutoEnzyme, source["mode"])[1]
    return ADTypes.AutoReactant(mode), JSON.skip(source)
end

end # module ADTypesEnzymeCoreJSONExt
