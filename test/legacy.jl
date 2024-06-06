@testset "AutoModelingToolkit" begin
    ad = @test_warn "AutoModelingToolkit(args...) is deprecated, use AutoSymbolics() or AutoSparse(AutoSymbolics()) instead." AutoModelingToolkit()
    @test ad isa AbstractADType
    ad = @test_warn "AutoModelingToolkit(args...) is deprecated, use AutoSymbolics() or AutoSparse(AutoSymbolics()) instead." AutoModelingToolkit(true)
    @test ad isa AbstractADType
    @test ad isa AutoSparse
    @test dense_ad(ad) isa AutoSymbolics
end

@testset "AutoSparseFastDifferentiation" begin
    ad = @test_deprecated AutoSparseFastDifferentiation()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoFastDifferentiation
end

@testset "AutoSparseFiniteDiff" begin
    ad = @test_deprecated AutoSparseFiniteDiff()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoFiniteDiff
    @test dense_ad(ad).fdtype === Val(:forward)
    @test dense_ad(ad).fdjtype === Val(:forward)
    @test dense_ad(ad).fdhtype === Val(:hcentral)
end

@testset "AutoSparseForwardDiff" begin
    ad = @test_deprecated AutoSparseForwardDiff()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoForwardDiff{nothing, Nothing}

    ad = @test_deprecated AutoSparseForwardDiff(; chunksize = 10, tag = CustomTag())
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoForwardDiff{10, CustomTag}
end

@testset "AutoSparsePolyesterForwardDiff" begin
    ad = @test_deprecated AutoSparsePolyesterForwardDiff(;
        chunksize = 10, tag = CustomTag())
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoPolyesterForwardDiff{10, CustomTag}
end

@testset "AutoSparseReverseDiff" begin
    ad = @test_deprecated AutoSparseReverseDiff(; compile = true)
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoReverseDiff
    @test dense_ad(ad).compile
end

@testset "AutoSparseZygote" begin
    ad = @test_deprecated AutoSparseZygote()
    @test ad isa AbstractADType
    @test dense_ad(ad) isa AutoZygote
end
