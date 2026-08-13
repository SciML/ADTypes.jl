module ADTypesDIStructTypesExt

using ADTypes
using DifferentiationInterface: DenseSparsityDetector
using StructTypes

# This extension's sole responsibility is to register DenseSparsityDetector
# as a known subtype of ADTypes.AbstractSparsityDetector when
# DifferentiationInterface is loaded.
#
# The StructType/subtypekey/subtypes definitions for AbstractSparsityDetector
# live in ADTypesStructTypesExt (defined exactly once there).  This extension
# adds its entry to the shared ADTypes._SPARSITY_DETECTOR_TYPES registry in
# __init__() so that StructTypes.subtypes() returns the right map at runtime.
#
# The StructTypes support for DenseSparsityDetector itself (CustomStruct
# lower/construct) lives in DifferentiationInterface.jl's own
# DifferentiationInterfaceStructTypesExt extension, where that type is defined.
# That keeps the serialization logic with the package that owns the types and
# avoids type piracy.

function __init__()
    ADTypes._SPARSITY_DETECTOR_TYPES[:DenseSparsityDetector] = DenseSparsityDetector
end

end # module ADTypesDIStructTypesExt
