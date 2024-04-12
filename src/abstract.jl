"""
    AbstractADType

Supertype for all AD choices.
"""
abstract type AbstractADType{mode} end

"""
    AbstractFiniteDifferencesMode

Supertype for AD choices that rely on [finite differences](https://en.wikipedia.org/wiki/Finite_difference).
"""
const AbstractFiniteDifferencesMode = AbstractADType{:finite}

"""
    AbstractForwardMode

Supertype for AD choices that rely on [forward mode](https://en.wikipedia.org/wiki/Automatic_differentiation#Forward_accumulation) algorithmic differentiation.
"""
const AbstractForwardMode = AbstractADType{:forward}

"""
    AbstractReverseMode

Supertype for AD choices that rely on [reverse mode](https://en.wikipedia.org/wiki/Automatic_differentiation#Reverse_accumulation) algorithmic differentiation.
"""
const AbstractReverseMode = AbstractADType{:reverse}

"""
    AbstractSymbolicDifferentiationMode

Supertype for AD choices that rely on [symbolic differentiation](https://en.wikipedia.org/wiki/Computer_algebra).
"""
const AbstractSymbolicDifferentiationMode = AbstractADType{:symbolic}

Base.broadcastable(ad::AbstractADType) = Ref(ad)
