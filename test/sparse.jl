for ad in every_ad()
    sparse_ad = AutoSparse(ad)
    @test sparse_ad isa AbstractADType
    if ad isa AbstractFiniteDifferencesMode
        @test sparse_ad isa AbstractFiniteDifferencesMode
        @test sparse_ad isa AbstractSparseFiniteDifferencesMode
    elseif ad isa AbstractForwardMode
        @test sparse_ad isa AbstractForwardMode
        @test sparse_ad isa AbstractSparseForwardMode
    elseif ad isa AbstractReverseMode
        @test sparse_ad isa AbstractReverseMode
        @test sparse_ad isa AbstractSparseReverseMode
    elseif ad isa AbstractSymbolicDifferentiationMode
        @test sparse_ad isa AbstractSymbolicDifferentiationMode
        @test sparse_ad isa AbstractSparseSymbolicDifferentiationMode
    end
    @test dense_ad(sparse_ad) == ad
    @test sparsity_detector(sparse_ad) == NoSparsityDetector()
    @test coloring_algorithm(sparse_ad) == NoColoringAlgorithm()
end
