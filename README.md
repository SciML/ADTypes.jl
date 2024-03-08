# ADTypes.jl: Multi-Valued Logic for Automatic Differentiation Choices

[![Build Status](https://github.com/Vaibhavdixit02/ADTypes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Vaibhavdixit02/ADTypes.jl/actions/workflows/CI.yml?query=branch%3Amain)

ADTypes.jl is a common system for implementing multi-valued logic for choosing which
automatic differentiation library to use.

## Which libraries are supported?

Just run the following code in a Julia REPL to find out:

```julia
julia> using ADTypes

julia> names(ADTypes)
15-element Vector{Symbol}:
 :ADTypes
 :AutoEnzyme
 :AutoFiniteDiff
 :AutoFiniteDifferences
 :AutoForwardDiff
 :AutoModelingToolkit
 :AutoPolyesterForwardDiff
 :AutoReverseDiff
 :AutoSparseFiniteDiff
 :AutoSparseForwardDiff
 :AutoSparsePolyesterForwardDiff
 :AutoSparseReverseDiff
 :AutoSparseZygote
 :AutoTracker
 :AutoZygote
```

Use the help mode of the Julia REPL to find out more about a specific library.

## Why Should Packages Adopt This?

The current standard is to have a keyword argument with `autodiff = true` or `autodiff = false`.
However, boolean logic is not sufficient to be able to do all of the choices that are
required. For example for forward-mode AD there is ForwardDiff vs Enzyme, and thus `true`
is ambgiuous. As libraries begin to support more and more of these autodiff mechanisms
for their trade-offs, every library will have their own version of `ChooseForwardDiff()`
etc. which would be a mess. Hence ADTypes.jl giving a single set of shared types for this.
`ADTypes.AutoForwardDiff()` is the way to do it.

## Why are they types instead of enums? Or EnumX?

If they were enums then they would not be dispatch type-level information. This is needed
for the internals of many of the packages to be type-stable because the choice of `config`
type is different per package, i.e. what needs to be cached in order to use everything in
a non-allocating manner.

## My AD Package is Missing?

Sure, give a PR to add it.
