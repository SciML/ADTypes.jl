module ADTypesStructTypesExt

using ADTypes
using StructTypes

# ── Abstract supertype registrations ──────────────────────────────────────────
#
# These tell JSON3 which key to use as the type discriminator when reading
# through an abstract-typed field, and which concrete type to construct.
#
# AbstractColoringAlgorithm is intentionally omitted here.  Its registration
# lives exclusively in ADTypesSMCStructTypesExt so that GreedyColoringAlgorithm
# can be included alongside NoColoringAlgorithm without any method overwriting.

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

end # module ADTypesStructTypesExt
