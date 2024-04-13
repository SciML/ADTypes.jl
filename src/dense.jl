"""
    AutoChainRules{RC}

Chooses any AD library based on [ChainRulesCore.jl](https://github.com/JuliaDiff/ChainRulesCore.jl), given an appropriate [`RuleConfig`](https://juliadiff.org/ChainRulesCore.jl/stable/rule_author/superpowers/ruleconfig.html) object.

# Fields

- `ruleconfig::RC`

# Constructor

    AutoChainRules(ruleconfig)
"""
Base.@kwdef struct AutoChainRules{RC} <: AbstractADType{:any}
    ruleconfig::RC
end

"""
    AutoDiffractor

Chooses [Diffractor.jl](https://github.com/JuliaDiff/Diffractor.jl).

# Constructor

    AutoDiffractor()
"""
struct AutoDiffractor <: AbstractADType{:any} end

"""
    AutoEnzyme{M}

Chooses [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl).

# Fields

- `mode::M = nothing`

# Constructor

    AutoEnzyme(mode)
"""
Base.@kwdef struct AutoEnzyme{M} <: AbstractADType{:any}
    mode::M = nothing
end

"""
    AutoFastDifferentiation

Chooses [FastDifferentiation.jl](https://github.com/brianguenter/FastDifferentiation.jl).

# Constructor

    AutoFastDifferentiation()
"""
struct AutoFastDifferentiation <: AbstractADType{:symbolic} end

"""
    AutoFiniteDiff{T1,T2,T3}

Chooses [FiniteDiff.jl](https://github.com/JuliaDiff/FiniteDiff.jl).

# Fields

- `fdtype::T1 = Val(:forward)`
- `fdjtype::T2 = fdtype`
- `fdhtype::T3 = Val(:hcentral)`

# Constructor

    AutoFiniteDiff(; fdtype, fdjtype, fdhtype)
"""
Base.@kwdef struct AutoFiniteDiff{T1, T2, T3} <: AbstractADType{:finite}
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
end

"""
    AutoFiniteDifferences{T}

Chooses [FiniteDifferences.jl](https://github.com/JuliaDiff/FiniteDifferences.jl).

# Fields

- `fdm::T = nothing`

# Constructor

    AutoFiniteDifferences(fdm)
"""
Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractADType{:finite}
    fdm::T = nothing
end

"""
    AutoForwardDiff{chunksize,T}

Chooses [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl).

# Fields

- `tag::T`

# Constructors

    AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize,T}(tag)
"""
struct AutoForwardDiff{chunksize, T} <: AbstractADType{:forward}
    tag::T
end

function AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize, typeof(tag)}(tag)
end

"""
    AutoModelingToolkit

Chooses [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl).

# Fields

- `obj_sparse::Bool = false`
- `cons_sparse::Bool = false`

# Constructor

    AutoModelingToolkit(; obj_sparse, cons_sparse)
"""
Base.@kwdef struct AutoModelingToolkit <: AbstractADType{:symbolic}
    obj_sparse::Bool = false
    cons_sparse::Bool = false
end

"""
    AutoPolyesterForwardDiff{chunksize}

Chooses [PolyesterForwardDiff.jl](https://github.com/JuliaDiff/PolyesterForwardDiff.jl).

# Constructors

    AutoPolyesterForwardDiff(; chunksize = nothing)
    AutoPolyesterForwardDiff{chunksize}()
"""
struct AutoPolyesterForwardDiff{chunksize} <: AbstractADType{:forward} end

function AutoPolyesterForwardDiff(; chunksize = nothing)
    AutoPolyesterForwardDiff{chunksize}()
end

"""
    AutoReverseDiff

Chooses [ReverseDiff.jl](https://github.com/JuliaDiff/ReverseDiff.jl).

# Fields

- `compile::Bool = false`

# Constructor

    AutoReverseDiff(compile)
"""
Base.@kwdef struct AutoReverseDiff <: AbstractADType{:reverse}
    compile::Bool = false
end

"""
    AutoTracker

Chooses [Tracker.jl](https://github.com/FluxML/Tracker.jl).

# Constructor

    AutoTracker()
"""
struct AutoTracker <: AbstractADType{:reverse} end

"""
    AutoZygote

Chooses [Zygote.jl](https://github.com/FluxML/Zygote.jl).

# Constructor

    AutoZygote()
"""
struct AutoZygote <: AbstractADType{:reverse} end
