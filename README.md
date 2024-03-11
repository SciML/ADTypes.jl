# ADTypes.jl: Multi-Valued Logic for Automatic Differentiation Choices

[![Docs stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://SciML.github.io/ADTypes.jl/stable/)
[![Docs dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://SciML.github.io/ADTypes.jl/dev/)
[![Build Status](https://github.com/SciML/ADTypes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SciML/ADTypes.jl/actions/workflows/CI.yml?query=branch%3Amain)

ADTypes.jl is a multi-valued logic system specifying the choice of an automatic differentiation (AD) library and its parameters.

## Which AD libraries are supported?

See the API reference in the documentation.

## Why should packages adopt this standard?

A common practice is the use of a boolean keyword argument like `autodiff = true/false`.
However, boolean logic is not precise enough for all the choices required.
For instance, forward mode AD is implemented by both ForwardDiff and Enzyme, which makes `autodiff = true` ambiguous.
Something like `ChooseForwardDiff()` is thus required, possibly with additional parameters depending on the library.

The risk is that every package developer might develop their own version of `ChooseForwardDiff()`, which would ruin interoperability.
This is why ADTypes.jl provides a single set of shared types for this task, as an extremely lightweight dependency.
Wonder no more: `ADTypes.AutoForwardDiff()` is the way to go.

## Why define types instead of enums?

If we used enums, they would not contain type-level information useful for dispatch.
This is needed by many AD libraries to ensure type stability.
Notably, the choice of config or cache type is different with each AD, so we must know statically which AD library is chosen.

## Why is this AD package missing?

Feel free to open a pull request adding it.
