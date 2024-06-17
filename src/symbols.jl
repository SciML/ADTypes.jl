"""
    ADTypes.Auto(package::Symbol)

A shortcut that converts an AD package name into an instance of [`AbstractADType`](@ref), with all parameters set to their default values.

!!! warning

    This function is type-unstable by design and might lead to suboptimal performance.
    In most cases, you should never need it: use the individual backend types directly.

# Example

```jldoctest
import ADTypes
backend = ADTypes.Auto(:Zygote)

# output

ADTypes.AutoZygote()
```
"""
Auto(package::Symbol) = Auto(Val(package))

Auto(::Val{:Diffractor}) = AutoDiffractor()
Auto(::Val{:Enzyme}) = AutoEnzyme()
Auto(::Val{:FastDifferentiation}) = AutoFastDifferentiation()
Auto(::Val{:FiniteDiff}) = AutoFiniteDiff()
Auto(::Val{:ForwardDiff}) = AutoForwardDiff()
Auto(::Val{:PolyesterForwardDiff}) = AutoPolyesterForwardDiff()
Auto(::Val{:ReverseDiff}) = AutoReverseDiff()
Auto(::Val{:Symbolics}) = AutoSymbolics()
Auto(::Val{:Tapir}) = AutoTapir()
Auto(::Val{:Tracker}) = AutoTracker()
Auto(::Val{:Zygote}) = AutoZygote()

function Auto(::Val{:ChainRules})
    throw(ArgumentError("ChainRules backend has mandatory arguments"))
end

function Auto(::Val{:FiniteDifferences})
    throw(ArgumentError("FiniteDifferences backend has mandatory arguments"))
end
