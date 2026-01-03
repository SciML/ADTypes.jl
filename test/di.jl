@testset "AutoDI" begin
    @testset "Subtyping and wrapping $ad_name" for (ad_name, ad) in [
        ("AutoForwardDiff", AutoForwardDiff()),
        ("AutoZygote", AutoZygote()),
        ("AutoEnzyme", AutoEnzyme()),
        ("AutoReverseDiff", AutoReverseDiff()),
        ("AutoChainRules", AutoChainRules(; ruleconfig = ForwardOrReverseRuleConfig())),
    ]
        di_ad = AutoDI(ad)
        @test di_ad isa AbstractADType
        @test di_ad isa AutoDI

        # Test mode propagation
        if mode(ad) isa ForwardMode
            @test mode(di_ad) isa ForwardMode
        elseif mode(ad) isa ForwardOrReverseMode
            @test mode(di_ad) isa ForwardOrReverseMode
        elseif mode(ad) isa ReverseMode
            @test mode(di_ad) isa ReverseMode
        elseif mode(ad) isa SymbolicMode
            @test mode(di_ad) isa SymbolicMode
        end

        # Test inner_ad accessor
        @test inner_ad(ad) == ad
        @test inner_ad(di_ad) == ad
    end
    
    @testset "All AD backends" begin
        for ad in every_ad()
            di_ad = AutoDI(ad)
            @test di_ad isa AbstractADType
            @test inner_ad(di_ad) == ad
            @test mode(di_ad) == mode(ad)
        end
    end
    
    @testset "Nested wrapping" begin
        # Test that we can wrap AutoDI with AutoSparse and vice versa
        ad = AutoForwardDiff()
        di_ad = AutoDI(ad)
        sparse_di_ad = AutoSparse(di_ad)
        
        @test sparse_di_ad isa AutoSparse
        @test dense_ad(sparse_di_ad) isa AutoDI
        @test inner_ad(dense_ad(sparse_di_ad)) == ad
        
        # Test AutoDI wrapping AutoSparse
        sparse_ad = AutoSparse(ad)
        di_sparse_ad = AutoDI(sparse_ad)
        
        @test di_sparse_ad isa AutoDI
        @test inner_ad(di_sparse_ad) isa AutoSparse
        @test dense_ad(inner_ad(di_sparse_ad)) == ad
    end
    
    @testset "Display" begin
        ad = AutoForwardDiff(chunksize = 5)
        di_ad = AutoDI(ad)
        
        str = sprint(show, di_ad)
        @test occursin("AutoDI", str)
        @test occursin("AutoForwardDiff", str)
    end
end
