module ADTypesSMCStructUtilsExt

using ADTypes
using StructUtils
using SparseMatrixColorings

# This extension's sole responsibility is to register GreedyColoringAlgorithm
# as a known subtype of ADTypes.AbstractColoringAlgorithm.
#
# The @choosetype definition for AbstractColoringAlgorithm lives in
# ADTypesStructUtilsExt (defined exactly once there).  This extension adds its
# entry to the shared ADTypes._COLORING_ALGORITHM_TYPES registry in __init__()
# so that @choosetype returns the right type at runtime.
#
# The StructUtils support for GreedyColoringAlgorithm and AbstractOrder
# (lower/make) lives in SparseMatrixColorings.jl's own
# SparseMatrixColoringsStructUtilsExt extension, where those types are defined.
# That keeps the serialization logic with the package that owns the types and
# avoids type piracy.

function __init__()
    ADTypes._COLORING_ALGORITHM_TYPES[:GreedyColoringAlgorithm] =
        SparseMatrixColorings.GreedyColoringAlgorithm
    return nothing
end

end # module ADTypesSMCStructUtilsExt
