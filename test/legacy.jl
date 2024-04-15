@testset "AutoSparseFastDifferentiation" begin
    ad = AutoSparseFastDifferentiation()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoFastDifferentiation
end

@testset "AutoSparseFiniteDiff" begin
    ad = AutoSparseFiniteDiff()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoFiniteDiff
    @test dense_ad(ad).fdtype === Val(:forward)
    @test dense_ad(ad).fdjtype === Val(:forward)
    @test dense_ad(ad).fdhtype === Val(:hcentral)
end

@testset "AutoSparseForwardDiff" begin
    ad = AutoSparseForwardDiff()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoForwardDiff{nothing, Nothing}

    ad = AutoSparseForwardDiff(; chunksize = 10, tag = CustomTag())
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoForwardDiff{10, CustomTag}
end

@testset "AutoSparsePolyesterForwardDiff" begin
    ad = AutoSparsePolyesterForwardDiff(; chunksize = 10, tag = CustomTag())
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoPolyesterForwardDiff{10, CustomTag}
end

@testset "AutoSparseReverseDiff" begin
    ad = AutoSparseReverseDiff(; compile = true)
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoReverseDiff
    @test dense_ad(ad).compile
end

@testset "AutoSparseZygote" begin
    ad = AutoSparseZygote()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoZygote
end
