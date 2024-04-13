@testset "Subtyping" begin
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

    @testset "Sparsity detector" begin
        sd = NoSparsityDetector()

        f_jac1(x) = vcat(x, x)
        f_jac2(x) = hcat(x, x)
        function f_jac! end
        f_hess(x) = sum(x)

        for x in (rand(2), rand(2, 3)), f in (f_jac1, f_jac2)
            y = f(x)
            Js = jacobian_sparsity(f, x, sd)
            @test Js isa AbstractMatrix
            @test size(Js) == (length(y), length(x))
            @test all(isone, Js)
        end

        for x in (rand(2), rand(2, 3)), y in (rand(5), rand(5, 6))
            Js = jacobian_sparsity(f_jac!, y, x, sd)
            @test Js isa AbstractMatrix
            @test size(Js) == (length(y), length(x))
            @test all(isone, Js)
        end

        for x in (rand(2), rand(2, 3))
            Hs = hessian_sparsity(f_hess, x, sd)
            @test Hs isa AbstractMatrix
            @test size(Hs) == (length(x), length(x))
            @test all(isone, Hs)
        end
    end
end

@testset "Coloring algorithm" begin
    ca = NoColoringAlgorithm()

    for M in (rand(2, 3), rand(3, 2))
        cv = column_coloring(M, ca)
        @test cv isa AbstractVector{<:Integer}
        @test length(cv) == size(M, 2)
        @test allunique(cv)

        rv = row_coloring(M, ca)
        @test rv isa AbstractVector{<:Integer}
        @test length(rv) == size(M, 1)
        @test allunique(rv)
    end
end
