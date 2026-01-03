"""
    AutoDI{I<:AbstractADType}

Wraps an ADTypes.jl object to signify that the DifferentiationInterface (DI) implementation of the wrapper function for that AD type should be used, rather than calling the native backend directly.

This allows packages to distinguish between an intention to directly call a corresponding AD tool vs. the DI wrapper for said tool, enabling the ability to use, test, and validate both approaches.

# Fields

  - `inner_ad::I`: the underlying AD package, subtyping [`AbstractADType`](@ref)

# Constructors

    AutoDI(inner_ad)

# Example

```jldoctest
julia> using ADTypes

julia> ad = AutoDI(AutoForwardDiff())
AutoDI(AutoForwardDiff())

julia> inner_ad(ad)
AutoForwardDiff()
```
"""
struct AutoDI{I <: AbstractADType} <: AbstractADType
    inner_ad::I
end

function Base.show(io::IO, backend::AutoDI)
    print(io, AutoDI, "(", repr(backend.inner_ad, context = io), ")")
end

"""
    inner_ad(ad::AutoDI)::AbstractADType
    inner_ad(ad::AbstractADType)::AbstractADType

Return the underlying AD package for a DI AD choice, act as the identity on a non-DI AD choice.

# See also

  - [`AutoDI`](@ref)
"""
inner_ad(ad::AutoDI) = ad.inner_ad
inner_ad(ad::AbstractADType) = ad

mode(di_ad::AutoDI) = mode(inner_ad(di_ad))
