module ADTypesStructTypesExt

using ADTypes
using StructTypes

# ── Abstract supertype registrations ──────────────────────────────────────────
#
# These tell JSON3 to include a "type" discriminator key when serializing
# through an abstract-typed field, and which concrete type to construct
# when deserializing.

StructTypes.StructType(::Type{ADTypes.AbstractADType}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractADType}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractADType}) = (
    AutoDiffractor          = ADTypes.AutoDiffractor,
    AutoFastDifferentiation = ADTypes.AutoFastDifferentiation,
    AutoSymbolics           = ADTypes.AutoSymbolics,
    AutoTracker             = ADTypes.AutoTracker,
    AutoZygote              = ADTypes.AutoZygote,
    NoAutoDiff              = ADTypes.NoAutoDiff,
    AutoSparse              = ADTypes.AutoSparse,
)

StructTypes.StructType(::Type{ADTypes.AbstractSparsityDetector}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractSparsityDetector}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractSparsityDetector}) = (
    NoSparsityDetector = ADTypes.NoSparsityDetector,
)

StructTypes.StructType(::Type{ADTypes.AbstractColoringAlgorithm}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractColoringAlgorithm}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractColoringAlgorithm}) = (
    NoColoringAlgorithm = ADTypes.NoColoringAlgorithm,
)

# ── Concrete types with no fields ─────────────────────────────────────────────

StructTypes.StructType(::Type{ADTypes.AutoDiffractor}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.AutoFastDifferentiation}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.AutoSymbolics}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.AutoTracker}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.AutoZygote}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.NoAutoDiff}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.NoSparsityDetector}) = StructTypes.Struct()
StructTypes.StructType(::Type{ADTypes.NoColoringAlgorithm}) = StructTypes.Struct()

# ── AutoSparse ─────────────────────────────────────────────────────────────────
#
# AutoSparse{D,S,C} is parameterized, so we lower it to a helper struct with
# abstract-typed fields. This causes JSON3 to use the AbstractType() registrations
# above when serializing/deserializing the nested objects, which inserts the
# "type" discriminator for each nested field.

struct _AutoSparseRepr
    dense_ad::ADTypes.AbstractADType
    sparsity_detector::ADTypes.AbstractSparsityDetector
    coloring_algorithm::ADTypes.AbstractColoringAlgorithm
end
StructTypes.StructType(::Type{_AutoSparseRepr}) = StructTypes.Struct()

StructTypes.StructType(::Type{<:ADTypes.AutoSparse}) = StructTypes.CustomStruct()

StructTypes.lower(x::ADTypes.AutoSparse) =
    _AutoSparseRepr(x.dense_ad, x.sparsity_detector, x.coloring_algorithm)

StructTypes.lowertype(::Type{<:ADTypes.AutoSparse}) = _AutoSparseRepr

function StructTypes.construct(::Type{<:ADTypes.AutoSparse}, x::_AutoSparseRepr)
    return ADTypes.AutoSparse(
        x.dense_ad;
        sparsity_detector  = x.sparsity_detector,
        coloring_algorithm = x.coloring_algorithm,
    )
end

end # module ADTypesStructTypesExt
