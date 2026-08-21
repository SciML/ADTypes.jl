using PrecompileTools: @compile_workload

@compile_workload begin
    forward_ad = AutoForwardDiff(; chunksize = 4)
    mode(forward_ad)
    mode(AutoReverseDiff(; compile = true))
    Auto(:ForwardDiff)
    Auto(nothing)

    sparse_ad = AutoSparse(forward_ad)
    dense_ad(sparse_ad)
    sparsity_detector(sparse_ad)
    coloring_algorithm(sparse_ad)

    x = [1.0, 2.0]
    f = x -> [x[1]^2, x[2]^2]
    jacobian_sparsity(f, x, NoSparsityDetector())
    hessian_sparsity(sum, x, NoSparsityDetector())

    pattern = trues(2, 2)
    jacobian_sparsity(f, x, KnownJacobianSparsityDetector(pattern))
    hessian_sparsity(sum, x, KnownHessianSparsityDetector(pattern))

    matrix = trues(2, 3)
    coloring = NoColoringAlgorithm()
    column_coloring(matrix, coloring)
    row_coloring(matrix, coloring)
    symmetric_coloring(pattern, coloring)
end
