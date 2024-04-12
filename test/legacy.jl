@testset "AutoSparseFastDifferentiation" begin
    adtype = AutoSparseFastDifferentiation()
    @test adtype isa AbstractADType
    @test adtype isa AbstractSymbolicDifferentiationMode
    @test dense_ad(adtype) isa AutoFastDifferentiation
end

@testset "AutoSparseFiniteDiff" begin
    adtype = AutoSparseFiniteDiff()
    @test adtype isa AbstractADType
    @test adtype isa AbstractFiniteDifferencesMode
    @test dense_ad(adtype) isa AutoFiniteDiff
    @test dense_ad(adtype).fdtype === Val(:forward)
    @test dense_ad(adtype).fdjtype === Val(:forward)
    @test dense_ad(adtype).fdhtype === Val(:hcentral)
end

@testset "AutoSparseForwardDiff" begin
    adtype = AutoSparseForwardDiff()
    @test adtype isa AbstractADType
    @test adtype isa AbstractForwardMode
    @test dense_ad(adtype) isa AutoForwardDiff{nothing, Nothing}

    adtype = AutoSparseForwardDiff(; chunksize = 10, tag = CustomTag())
    @test adtype isa AbstractADType
    @test adtype isa AbstractForwardMode
    @test dense_ad(adtype) isa AutoForwardDiff{10, CustomTag}
end

@testset "AutoSparsePolyesterForwardDiff" begin
    adtype = AutoSparsePolyesterForwardDiff(; chunksize = 10)
    @test adtype isa AbstractADType
    @test adtype isa AbstractForwardMode
    @test dense_ad(adtype) isa AutoPolyesterForwardDiff{10}
end

@testset "AutoSparseReverseDiff" begin
    adtype = AutoSparseReverseDiff(; compile = true)
    @test adtype isa AbstractADType
    @test adtype isa AbstractReverseMode
    @test dense_ad(adtype) isa AutoReverseDiff
    @test dense_ad(adtype).compile
end

@testset "AutoSparseZygote" begin
    adtype = AutoSparseZygote()
    @test adtype isa AbstractADType
    @test adtype isa AbstractReverseMode
    @test dense_ad(adtype) isa AutoZygote
end
