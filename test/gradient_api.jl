using ADTypes: GradientOrder, gradient_order

struct UnimplementedBackend <: AbstractADType end

@testset "GradientOrder trait" begin
    @test GradientOrder{0}() isa GradientOrder
    @test GradientOrder{1}() isa GradientOrder
    @test GradientOrder{0}() < GradientOrder{1}()
    @test GradientOrder{1}() < GradientOrder{2}()
    @test !(GradientOrder{1}() < GradientOrder{1}())
    @test_throws ArgumentError GradientOrder{-1}()
end

@testset "gradient_order" begin
    @test gradient_order(UnimplementedBackend()) === nothing
end

@testset "Error fallbacks" begin
    f = x -> x^2
    backend = UnimplementedBackend()
    @test_throws ArgumentError ADTypes.value_and_gradient!!(f, backend, 1.0)
    @test_throws ArgumentError ADTypes.value_and_jacobian!!(f, backend, 1.0)
end
