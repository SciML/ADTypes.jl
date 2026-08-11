module ADTypesJSON3Ext

using ADTypes
using JSON3
using StructTypes  # ensures ADTypesStructTypesExt is loaded first

# ── write_ad ──────────────────────────────────────────────────────────────────
#
# Each concrete ADType is serialized via CustomStruct with a _TypedRepr helper
# (defined in ADTypesStructTypesExt) that always includes the "type" key.
# JSON3.write therefore always produces a complete, round-trippable object with
# no manual string manipulation required.

function ADTypes.write_ad(ad::ADTypes.AbstractADType)
    return JSON3.write(ad)
end

# ── read_ad ───────────────────────────────────────────────────────────────────
#
# Reading through AbstractADType triggers StructTypes.AbstractType() dispatch,
# which reads the "type" key and constructs the correct concrete subtype.

function ADTypes.read_ad(json::AbstractString)
    return JSON3.read(json, ADTypes.AbstractADType)
end

end # module ADTypesJSON3Ext
