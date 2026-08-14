module ADTypesSMCStructTypesExt

using ADTypes
using StructTypes
using SparseMatrixColorings

# This extension's sole responsibility is to register GreedyColoringAlgorithm
# as a known subtype of ADTypes.AbstractColoringAlgorithm.
#
# The StructType/subtypekey/subtypes definitions for AbstractColoringAlgorithm
# live in ADTypesStructTypesExt (defined exactly once there).  This extension
# adds its entry to the shared ADTypes._COLORING_ALGORITHM_TYPES registry in
# __init__() so that StructTypes.subtypes() returns the right map at runtime.
#
# The StructTypes support for GreedyColoringAlgorithm itself (and for
# AbstractOrder and its subtypes) lives in SparseMatrixColorings.jl's own
# SparseMatrixColoringsStructTypesExt extension, where those types are defined.
# That keeps the serialization logic with the package that owns the types and
# avoids type piracy.

function __init__()
    ADTypes._COLORING_ALGORITHM_TYPES[:GreedyColoringAlgorithm] =
        SparseMatrixColorings.GreedyColoringAlgorithm
    return nothing
end

end # module ADTypesSMCStructTypesExt
