module ADTypes

"""
Base type for AD choices.
"""
abstract type AbstractADType end

Base.@kwdef struct AutoFiniteDiff{T1, T2, T3} <: AbstractADType
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
end

Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractADType
    fdm::T = nothing
end

struct AutoForwardDiff{chunksize, T} <: AbstractADType
    tag::T
end

function AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize, typeof(tag)}(tag)
end

Base.@kwdef struct AutoReverseDiff <: AbstractADType
    compile::Bool = false
end

struct AutoZygote <: AbstractADType end

Base.@kwdef struct AutoEnzyme{M} <: AbstractADType
    mode::M = nothing
end

struct AutoTracker <: AbstractADType end

Base.@kwdef struct AutoModelingToolkit <: AbstractADType
    obj_sparse::Bool = false
    cons_sparse::Bool = false
end

struct AutoSparseFiniteDiff <: AbstractADType end

struct AutoSparseForwardDiff{chunksize, T} <: AbstractADType
    tag::T
end

function AutoSparseForwardDiff(; chunksize = nothing, tag = nothing)
    AutoSparseForwardDiff{chunksize, typeof(tag)}(tag)
end

export AutoFiniteDiff,
       AutoFiniteDifferences,
       AutoForwardDiff,
       AutoReverseDiff,
       AutoZygote,
       AutoEnzyme,
       AutoTracker,
       AutoModelingToolkit,
       AutoSparseFiniteDiff,
       AutoSparseForwardDiff
end
