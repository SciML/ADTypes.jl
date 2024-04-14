"""
    AbstractMode

Abstract supertype for the traits identifying differentiation modes.

# Subtypes

- [`FiniteDifferencesMode`](@ref)
- [`ForwardMode`](@ref)
- [`ReverseMode`](@ref)
- [`ForwardOrReverseMode`](@ref)
- [`SymbolicMode`](@ref)
"""
abstract type AbstractMode end

"""
    mode(ad::AbstractADType)

Return the differentiation mode of `ad`, as a subtype of [`AbstractMode`](@ref).
"""
function mode end

"""
    FiniteDifferencesMode

Trait for AD choices that rely on [finite differences](https://en.wikipedia.org/wiki/Finite_difference).
"""
struct FiniteDifferencesMode <: AbstractMode end

"""
    ForwardMode

Trait for AD choices that rely on [forward mode](https://en.wikipedia.org/wiki/Automatic_differentiation#Forward_accumulation) algorithmic differentiation.
"""
struct ForwardMode <: AbstractMode end

"""
    ReverseMode

Trait for AD choices that rely on [reverse mode](https://en.wikipedia.org/wiki/Automatic_differentiation#Reverse_accumulation) algorithmic differentiation.
"""
struct ReverseMode <: AbstractMode end

"""
    ForwardOrReverseMode

Trait for AD choices that can rely on either [forward mode](https://en.wikipedia.org/wiki/Automatic_differentiation#Forward_accumulation) or [reverse mode](https://en.wikipedia.org/wiki/Automatic_differentiation#Reverse_accumulation) algorithmic differentiation, depending on their configuration.

!!! warning
    This trait should rarely be used, because more precise dispatches to [`ForwardMode`](@ref) or [`ReverseMode`](@ref) should be defined. 
"""
struct ForwardOrReverseMode <: AbstractMode end

"""
    SymbolicMode

Trait for AD choices that rely on [symbolic differentiation](https://en.wikipedia.org/wiki/Computer_algebra)
"""
struct SymbolicMode <: AbstractMode end
