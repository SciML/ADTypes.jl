@testset "Broadcasting" begin
    for ad in every_ad()
        @test identity.(ad) == ad
    end
end

@testset "Printing" begin
    for ad in every_ad_with_options()
        @test startswith(string(ad), "Auto")
        @test endswith(string(ad), ")")
    end

    sparse_backend1 = AutoSparse(AutoForwardDiff())
    sparse_backend2 = AutoSparse(
        AutoForwardDiff();
        sparsity_detector = FakeSparsityDetector(),
        coloring_algorithm = FakeColoringAlgorithm()
    )
    @test contains(string(sparse_backend1), string(AutoForwardDiff()))
    @test length(string(sparse_backend1)) < length(string(sparse_backend2))
end
