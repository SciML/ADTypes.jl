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

```@docs
AutoForwardDiff
AutoPolyesterForwardDiff
```

### Reverse mode

```@docs
AutoReverseDiff
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
AutoModelingToolkit
```

### Finite differences mode

```@docs
AutoFiniteDiff
AutoFiniteDifferences
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
ADTypes.NoSparsityDetector
```

### Coloring algorithm

```@docs
ADTypes.coloring_algorithm
ADTypes.AbstractColoringAlgorithm
ADTypes.NoColoringAlgorithm
```

## Internals

```@docs
AbstractFiniteDifferencesMode
AbstractForwardMode
AbstractReverseMode
AbstractSymbolicDifferentiationMode
```
