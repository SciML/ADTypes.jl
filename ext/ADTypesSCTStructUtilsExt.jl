module ADTypesSCTStructUtilsExt

using ADTypes
using StructUtils
using SparseConnectivityTracer

# This extension's sole responsibility is to register TracerSparsityDetector
# and TracerLocalSparsityDetector as known subtypes of
# ADTypes.AbstractSparsityDetector.
#
# The @choosetype definition for AbstractSparsityDetector lives in
# ADTypesStructUtilsExt (defined exactly once there).  This extension adds its
# entries to the shared ADTypes._SPARSITY_DETECTOR_TYPES registry in __init__()
# so that @choosetype returns the right type at runtime.
#
# The StructUtils support for the detector types themselves (lower/make) lives
# in SparseConnectivityTracer.jl's own SparseConnectivityTracerStructUtilsExt
# extension, where those types are defined.  That keeps the serialization logic
# with the package that owns the types and avoids type piracy.

function __init__()
    ADTypes._SPARSITY_DETECTOR_TYPES[:TracerSparsityDetector] =
        SparseConnectivityTracer.TracerSparsityDetector
    ADTypes._SPARSITY_DETECTOR_TYPES[:TracerLocalSparsityDetector] =
        SparseConnectivityTracer.TracerLocalSparsityDetector
    return nothing
end

end # module ADTypesSCTStructUtilsExt
