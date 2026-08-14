module ADTypesSCTStructTypesExt

using ADTypes
using StructTypes
using SparseConnectivityTracer

# This extension's sole responsibility is to register TracerSparsityDetector
# and TracerLocalSparsityDetector as known subtypes of
# ADTypes.AbstractSparsityDetector.
#
# The StructType/subtypekey/subtypes definitions for AbstractSparsityDetector
# live in ADTypesStructTypesExt (defined exactly once there).  This extension
# adds its entries to the shared ADTypes._SPARSITY_DETECTOR_TYPES registry in
# __init__() so that StructTypes.subtypes() returns the right map at runtime.
#
# The StructTypes support for the detector types themselves (CustomStruct
# lower/construct) lives in SparseConnectivityTracer.jl's own
# SparseConnectivityTracerStructTypesExt extension, where those types are
# defined.  That keeps the serialization logic with the package that owns the
# types and avoids type piracy.

function __init__()
    ADTypes._SPARSITY_DETECTOR_TYPES[:TracerSparsityDetector] =
        SparseConnectivityTracer.TracerSparsityDetector
    ADTypes._SPARSITY_DETECTOR_TYPES[:TracerLocalSparsityDetector] =
        SparseConnectivityTracer.TracerLocalSparsityDetector
    return nothing
end

end # module ADTypesSCTStructTypesExt
