module ADTypesDIStructUtilsExt

using ADTypes
using StructUtils
using DifferentiationInterface

# This extension's sole responsibility is to register DenseSparsityDetector
# as a known subtype of ADTypes.AbstractSparsityDetector.
#
# The @choosetype definition for AbstractSparsityDetector lives in
# ADTypesStructUtilsExt (defined exactly once there).  This extension adds its
# entry to the shared ADTypes._SPARSITY_DETECTOR_TYPES registry in __init__()
# so that @choosetype returns the right type at runtime.
#
# The StructUtils support for DenseSparsityDetector (lower/make) lives in
# DifferentiationInterface.jl's own DifferentiationInterfaceStructUtilsExt
# extension, where the type is defined.  That keeps the serialization logic
# with the package that owns the type and avoids type piracy.

function __init__()
    ADTypes._SPARSITY_DETECTOR_TYPES[:DenseSparsityDetector] =
        DifferentiationInterface.DenseSparsityDetector
    return nothing
end

end # module ADTypesDIStructUtilsExt
