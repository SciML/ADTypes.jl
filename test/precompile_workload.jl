using ADTypes
using ADTypes: Auto, AutoForwardDiff, AutoReverseDiff, AutoSparse, ForwardMode,
    ReverseMode, NoAutoDiff, dense_ad, sparsity_detector, coloring_algorithm,
    NoSparsityDetector, KnownJacobianSparsityDetector,
    KnownHessianSparsityDetector, jacobian_sparsity, hessian_sparsity,
    NoColoringAlgorithm, column_coloring, row_coloring, symmetric_coloring, mode
using Test

forward_ad = AutoForwardDiff(; chunksize = 4)
@test mode(forward_ad) isa ForwardMode
@test mode(AutoReverseDiff(; compile = true)) isa ReverseMode
@test Auto(:ForwardDiff) isa AutoForwardDiff
@test Auto(nothing) isa NoAutoDiff

sparse_ad = AutoSparse(forward_ad)
@test dense_ad(sparse_ad) === forward_ad
@test sparsity_detector(sparse_ad) isa NoSparsityDetector
@test coloring_algorithm(sparse_ad) isa NoColoringAlgorithm

x = [1.0, 2.0]
f(x) = [x[1]^2, x[2]^2]
@test jacobian_sparsity(f, x, NoSparsityDetector()) == trues(2, 2)
@test hessian_sparsity(sum, x, NoSparsityDetector()) == trues(2, 2)

pattern = trues(2, 2)
@test jacobian_sparsity(f, x, KnownJacobianSparsityDetector(pattern)) === pattern
@test hessian_sparsity(sum, x, KnownHessianSparsityDetector(pattern)) === pattern

matrix = trues(2, 3)
coloring = NoColoringAlgorithm()
@test column_coloring(matrix, coloring) == 1:3
@test row_coloring(matrix, coloring) == 1:2
@test symmetric_coloring(pattern, coloring) == 1:2
