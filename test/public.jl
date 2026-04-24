using ADTypes
using Test

public_symbols = (
    :AbstractMode,
    :ForwardMode,
    :ReverseMode,
    :ForwardOrReverseMode,
    :SymbolicMode,
    :mode,
    :Auto,
    # Sparse Automatic Differentiation
    :dense_ad,
    # Sparsity detection
    :sparsity_detector,
    :NoSparsityDetector,
    :KnownJacobianSparsityDetector,
    :KnownHessianSparsityDetector,
    # Matrix coloring
    :coloring_algorithm,
    :NoColoringAlgorithm,
    # Gradient API
    :GradientOrder,
    :gradient_order,
    :value_and_gradient!!,
    :value_and_jacobian!!,
)
@test public_symbols ⊆ names(ADTypes)
