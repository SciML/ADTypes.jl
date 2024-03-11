var documenterSearchIndex = {"docs":
[{"location":"","page":"ADTypes.jl","title":"ADTypes.jl","text":"CurrentModule = ADTypes\nCollapsedDocStrings = true","category":"page"},{"location":"#ADTypes.jl","page":"ADTypes.jl","title":"ADTypes.jl","text":"","category":"section"},{"location":"","page":"ADTypes.jl","title":"ADTypes.jl","text":"Documentation for ADTypes.jl.","category":"page"},{"location":"#Public","page":"ADTypes.jl","title":"Public","text":"","category":"section"},{"location":"","page":"ADTypes.jl","title":"ADTypes.jl","text":"Modules = [ADTypes]\nPrivate = false","category":"page"},{"location":"#ADTypes.ADTypes","page":"ADTypes.jl","title":"ADTypes.ADTypes","text":"ADTypes.jl\n\nADTypes.jl is a common system for implementing multi-valued logic for choosing which automatic differentiation library to use.\n\n\n\n\n\n","category":"module"},{"location":"#ADTypes.AutoChainRules","page":"ADTypes.jl","title":"ADTypes.AutoChainRules","text":"AutoChainRules{RC}\n\nChooses any AD library based on ChainRulesCore.jl, given an appropriate RuleConfig object.\n\nFields\n\nruleconfig::RC\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoDiffractor","page":"ADTypes.jl","title":"ADTypes.AutoDiffractor","text":"AutoDiffractor\n\nChooses Diffractor.jl.\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoEnzyme","page":"ADTypes.jl","title":"ADTypes.AutoEnzyme","text":"AutoEnzyme{M}\n\nChooses Enzyme.jl.\n\nFields\n\nmode::M = nothing\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoFiniteDiff","page":"ADTypes.jl","title":"ADTypes.AutoFiniteDiff","text":"AutoFiniteDiff{T1,T2,T3}\n\nChooses FiniteDiff.jl.\n\nFields\n\nfdtype::T1 = Val(:forward)\nfdjtype::T2 = fdtype\nfdhtype::T3 = Val(:hcentral)\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoFiniteDifferences","page":"ADTypes.jl","title":"ADTypes.AutoFiniteDifferences","text":"AutoFiniteDifferences{T}\n\nChooses FiniteDifferences.jl.\n\nFields\n\nfdm::T = nothing\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoForwardDiff","page":"ADTypes.jl","title":"ADTypes.AutoForwardDiff","text":"AutoForwardDiff{chunksize,T}\n\nChooses ForwardDiff.jl.\n\nFields\n\ntag::T\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoForwardDiff-Tuple{}","page":"ADTypes.jl","title":"ADTypes.AutoForwardDiff","text":"AutoForwardDiff(; chunksize = nothing, tag = nothing)\n\nConstructor.\n\n\n\n\n\n","category":"method"},{"location":"#ADTypes.AutoModelingToolkit","page":"ADTypes.jl","title":"ADTypes.AutoModelingToolkit","text":"AutoModelingToolkit\n\nChooses ModelingToolkit.jl.\n\nFields\n\nobj_sparse::Bool = false\ncons_sparse::Bool = false\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoPolyesterForwardDiff","page":"ADTypes.jl","title":"ADTypes.AutoPolyesterForwardDiff","text":"AutoPolyesterForwardDiff{chunksize}\n\nChooses PolyesterForwardDiff.jl.\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoPolyesterForwardDiff-Tuple{}","page":"ADTypes.jl","title":"ADTypes.AutoPolyesterForwardDiff","text":"AutoPolyesterForwardDiff(; chunksize = nothing)\n\nConstructor.\n\n\n\n\n\n","category":"method"},{"location":"#ADTypes.AutoReverseDiff","page":"ADTypes.jl","title":"ADTypes.AutoReverseDiff","text":"AutoReverseDiff\n\nChooses ReverseDiff.jl.\n\nFields\n\ncompile::Bool = false\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoSparseFiniteDiff","page":"ADTypes.jl","title":"ADTypes.AutoSparseFiniteDiff","text":"AutoSparseFiniteDiff\n\nChooses FiniteDiff.jl while exploiting sparsity.\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoSparseForwardDiff","page":"ADTypes.jl","title":"ADTypes.AutoSparseForwardDiff","text":"AutoSparseForwardDiff{chunksize,T}\n\nChooses ForwardDiff.jl while exploiting sparsity.\n\nFields\n\ntag::T\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoSparseForwardDiff-Tuple{}","page":"ADTypes.jl","title":"ADTypes.AutoSparseForwardDiff","text":"AutoSparseForwardDiff(; chunksize = nothing, tag = nothing)\n\nConstructor.\n\n\n\n\n\n","category":"method"},{"location":"#ADTypes.AutoSparsePolyesterForwardDiff","page":"ADTypes.jl","title":"ADTypes.AutoSparsePolyesterForwardDiff","text":"AutoSparsePolyesterForwardDiff{chunksize}\n\nChooses PolyesterForwardDiff.jl while exploiting sparsity.\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoSparsePolyesterForwardDiff-Tuple{}","page":"ADTypes.jl","title":"ADTypes.AutoSparsePolyesterForwardDiff","text":"AutoSparsePolyesterForwardDiff(; chunksize = nothing)\n\nConstructor.\n\n\n\n\n\n","category":"method"},{"location":"#ADTypes.AutoSparseReverseDiff","page":"ADTypes.jl","title":"ADTypes.AutoSparseReverseDiff","text":"AutoSparseReverseDiff\n\nChooses ReverseDiff.jl while exploiting sparsity.\n\nFields\n\ncompile::Bool = false\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoSparseZygote","page":"ADTypes.jl","title":"ADTypes.AutoSparseZygote","text":"AutoSparseZygote\n\nChooses Zygote.jl while exploiting sparsity.\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoTracker","page":"ADTypes.jl","title":"ADTypes.AutoTracker","text":"AutoTracker\n\nChooses Tracker.jl.\n\n\n\n\n\n","category":"type"},{"location":"#ADTypes.AutoZygote","page":"ADTypes.jl","title":"ADTypes.AutoZygote","text":"AutoZygote\n\nChooses Zygote.jl.\n\n\n\n\n\n","category":"type"},{"location":"#Internal","page":"ADTypes.jl","title":"Internal","text":"","category":"section"},{"location":"","page":"ADTypes.jl","title":"ADTypes.jl","text":"Modules = [ADTypes]\nPublic = false","category":"page"},{"location":"#ADTypes.AbstractADType","page":"ADTypes.jl","title":"ADTypes.AbstractADType","text":"Base type for AD choices.\n\n\n\n\n\n","category":"type"}]
}
