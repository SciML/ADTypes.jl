@testset "Broadcasting" begin
    for ad in every_ad()
        @test identity.(ad) == ad
    end
end

@testset "Printing" begin
    for ad in every_ad_with_options()
        @test startswith(string(ad), "Auto")
        @test contains(string(ad), "(")
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

import ADTypes

struct FakeSparsityDetector <: ADTypes.AbstractSparsityDetector end
struct FakeColoringAlgorithm <: ADTypes.AbstractColoringAlgorithm end

for backend in [
    # dense
    ADTypes.AutoChainRules(; ruleconfig = :rc),
    ADTypes.AutoDiffractor(),
    ADTypes.AutoEnzyme(),
    ADTypes.AutoEnzyme(mode = :forward),
    ADTypes.AutoFastDifferentiation(),
    ADTypes.AutoFiniteDiff(),
    ADTypes.AutoFiniteDiff(fdtype = :fd, fdjtype = :fdj, fdhtype = :fdh),
    ADTypes.AutoFiniteDifferences(; fdm = :fdm),
    ADTypes.AutoForwardDiff(),
    ADTypes.AutoForwardDiff(chunksize = 3, tag = :tag),
    ADTypes.AutoPolyesterForwardDiff(),
    ADTypes.AutoPolyesterForwardDiff(chunksize = 3, tag = :tag),
    ADTypes.AutoReverseDiff(),
    ADTypes.AutoReverseDiff(compile = true),
    ADTypes.AutoSymbolics(),
    ADTypes.AutoTapir(),
    ADTypes.AutoTapir(safe_mode = false),
    ADTypes.AutoTracker(),
    ADTypes.AutoZygote(),
    # sparse
    ADTypes.AutoSparse(ADTypes.AutoForwardDiff()),
    ADTypes.AutoSparse(
        ADTypes.AutoForwardDiff();
        sparsity_detector = FakeSparsityDetector(),
        coloring_algorithm = FakeColoringAlgorithm()
    )
]
    println(backend)
end
