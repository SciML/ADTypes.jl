module ADTypesSMCStructTypesExt

using ADTypes
using StructTypes
using SparseMatrixColorings

# This extension's sole responsibility is to register GreedyColoringAlgorithm
# as a known subtype of ADTypes.AbstractColoringAlgorithm.
#
# The StructTypes support for GreedyColoringAlgorithm itself (and for
# AbstractOrder and its subtypes) lives in SparseMatrixColorings.jl's own
# SparseMatrixColoringsStructTypesExt extension, where those types are defined.
# That keeps the serialization logic with the package that owns the types and
# avoids type piracy.
#
# This definition replaces the one from ADTypesStructTypesExt (which only knows
# about NoColoringAlgorithm).  Since this extension is loaded after
# ADTypesStructTypesExt (it requires more packages), its definition takes
# precedence at runtime when both are loaded.

StructTypes.StructType(::Type{ADTypes.AbstractColoringAlgorithm}) = StructTypes.AbstractType()
StructTypes.subtypekey(::Type{ADTypes.AbstractColoringAlgorithm}) = :type
StructTypes.subtypes(::Type{ADTypes.AbstractColoringAlgorithm}) = (
    NoColoringAlgorithm     = ADTypes.NoColoringAlgorithm,
    GreedyColoringAlgorithm = SparseMatrixColorings.GreedyColoringAlgorithm,
)

end # module ADTypesSMCStructTypesExt
