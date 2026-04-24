## Capability trait

"""
    GradientOrder{K}

Trait indicating that an AD backend supports computing derivatives up to order `K`:

  - `GradientOrder{0}()`: primal evaluation only
  - `GradientOrder{1}()`: value + gradient / Jacobian
  - `GradientOrder{2}()`: value + gradient + Hessian

Backends declare their capability by implementing [`gradient_order`](@ref).
Consumers can compare orders: `GradientOrder{1}() ≤ GradientOrder{2}()`.
"""
struct GradientOrder{K}
    function GradientOrder{K}() where {K}
        _K = Int(K)
        _K ≥ 0 || throw(ArgumentError("GradientOrder requires K ≥ 0, got $_K"))
        new{_K}()
    end
end

GradientOrder(K::Integer) = GradientOrder{Int(K)}()

Base.isless(::GradientOrder{J}, ::GradientOrder{K}) where {J, K} = J < K

"""
    gradient_order(backend::AbstractADType) -> GradientOrder{K} or nothing

Return the [`GradientOrder`](@ref) supported by `backend`, or `nothing` if the backend
does not implement the ADTypes gradient API.

Backends declare support by adding a method:

    ADTypes.gradient_order(::MyBackend) = GradientOrder{1}()
"""
gradient_order(::AbstractADType) = nothing

## Interface functions

"""
    value_and_gradient!!(f, backend::AbstractADType, x)

Compute the primal value `y = f(x)` and gradient `∇f(x)` for a scalar-valued function `f`.

Returns `(y, g)` where `g` has the same structure as `x`.

The `!!` signals that the backend may mutate internal cache state. The caller owns the
returned values: mutable components (e.g. gradient arrays) may be overwritten on the next
call with the same backend, so copy if you need to retain them.

# Interface

Backends supporting first-order derivatives implement:

    ADTypes.value_and_gradient!!(f, ::MyBackend, x) = ...

and declare:

    ADTypes.gradient_order(::MyBackend) = GradientOrder{1}()

See also: [`value_and_jacobian!!`](@ref), [`gradient_order`](@ref).
"""
function value_and_gradient!! end

"""
    value_and_jacobian!!(f, backend::AbstractADType, x)

Compute the primal value `y = f(x)` and the Jacobian `∂f(x)` for a general function `f`.

  - If `f` is scalar-valued, this is equivalent to [`value_and_gradient!!`](@ref).
  - If `f` is vector-valued (`f : ℝⁿ → ℝᵐ`), returns the full `m × n` Jacobian matrix.

The `!!` signals that the backend may mutate internal cache state. The caller owns the
returned values.

# Interface

Backends implement:

    ADTypes.value_and_jacobian!!(f, ::MyBackend, x) = ...

See also: [`value_and_gradient!!`](@ref), [`gradient_order`](@ref).
"""
function value_and_jacobian!! end

## Error fallbacks

function value_and_gradient!!(f::F, ::T, x) where {F, T<:AbstractADType}
    throw(ArgumentError(
        "`ADTypes.value_and_gradient!!` is not implemented for backend `$T`. " *
        "Add a method:\n    ADTypes.value_and_gradient!!(f, ::$T, x) = ...\n" *
        "and declare:\n    ADTypes.gradient_order(::$T) = GradientOrder{1}()"
    ))
end

function value_and_jacobian!!(f::F, ::T, x) where {F, T<:AbstractADType}
    throw(ArgumentError(
        "`ADTypes.value_and_jacobian!!` is not implemented for backend `$T`. " *
        "Add a method:\n    ADTypes.value_and_jacobian!!(f, ::$T, x) = ...\n" *
        "and declare:\n    ADTypes.gradient_order(::$T) = GradientOrder{1}()"
    ))
end
