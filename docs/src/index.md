```@meta
CurrentModule = ADTypes
CollapsedDocStrings = true
```

# ADTypes.jl

Documentation for [ADTypes.jl](https://github.com/SciML/ADTypes.jl/).

```@docs
ADTypes
AbstractADType
```

## Dense AD

### Forward mode

Algorithmic differentiation:

```@docs
AutoForwardDiff
AutoPolyesterForwardDiff
```

Finite differences:

```@docs
AutoFiniteDiff
AutoFiniteDifferences
```

### Reverse mode

```@docs
AutoReverseDiff
AutoTapir
AutoTracker
AutoZygote
```

### Forward or reverse mode

```@docs
AutoEnzyme
AutoChainRules
AutoDiffractor
```

### Symbolic mode

```@docs
AutoFastDifferentiation
AutoSymbolics
```

## Sparse AD

```@docs
AutoSparse
ADTypes.dense_ad
```

### Sparsity detector

```@docs
ADTypes.sparsity_detector
ADTypes.AbstractSparsityDetector
ADTypes.jacobian_sparsity
ADTypes.hessian_sparsity
ADTypes.NoSparsityDetector
```

### Coloring algorithm

```@docs
ADTypes.coloring_algorithm
ADTypes.AbstractColoringAlgorithm
ADTypes.column_coloring
ADTypes.row_coloring
ADTypes.NoColoringAlgorithm
```

## Modes

```@docs
ADTypes.mode
ADTypes.AbstractMode
ADTypes.ForwardMode
ADTypes.ForwardOrReverseMode
ADTypes.ReverseMode
ADTypes.SymbolicMode
```
