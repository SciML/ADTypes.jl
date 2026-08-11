module ADTypesJSON3Ext

using ADTypes
using JSON3
using StructTypes  # ensures ADTypesStructTypesExt is loaded first

# ── write_ad ──────────────────────────────────────────────────────────────────
#
# JSON3.write(ad) uses the concrete type's StructType, which produces fields
# only (no "type" key). To always include the type discriminator we:
#   1. Serialize the concrete type's fields with JSON3.write(ad) → e.g. "{}"
#      or {"dense_ad":{...},...}
#   2. Prepend "type":"TypeName" to form a complete, round-trippable object.
#
# For AutoSparse the nested dense_ad / sparsity_detector / coloring_algorithm
# fields are already serialized with their own "type" keys because
# _AutoSparseRepr (defined in ADTypesStructTypesExt) has abstract-typed fields.

function ADTypes.write_ad(ad::ADTypes.AbstractADType)
    type_name = String(nameof(typeof(ad)))
    fields_str = JSON3.write(ad)
    if fields_str == "{}"
        return """{"type":"$type_name"}"""
    else
        # fields_str is a JSON object like {"k":v,...}; insert "type" at the front.
        return """{"type":"$type_name",""" * fields_str[2:end]
    end
end

# ── read_ad ───────────────────────────────────────────────────────────────────
#
# Reading through AbstractADType triggers StructTypes.AbstractType() dispatch,
# which reads the "type" key and constructs the correct concrete subtype.

function ADTypes.read_ad(json::AbstractString)
    return JSON3.read(json, ADTypes.AbstractADType)
end

end # module ADTypesJSON3Ext
