module ADTypes

"""
Base type for AD choices.
"""
abstract type AbstractADType end

abstract type AbstractReverseMode <: AbstractADType end
abstract type AbstractForwardMode <: AbstractADType end
abstract type AbstractFiniteDifferencesMode <: AbstractADType end
abstract type AbstractSymbolicDifferentiationMode <: AbstractADType end

abstract type AbstractSparseReverseMode <: AbstractReverseMode end
abstract type AbstractSparseForwardMode <: AbstractForwardMode end
abstract type AbstractSparseFiniteDifferences <: AbstractFiniteDifferencesMode end

Base.@kwdef struct AutoChainRules{RC} <: AbstractADType
    ruleconfig::RC
end

Base.@kwdef struct AutoFiniteDiff{T1, T2, T3} <: AbstractFiniteDifferencesMode
    fdtype::T1 = Val(:forward)
    fdjtype::T2 = fdtype
    fdhtype::T3 = Val(:hcentral)
end

Base.@kwdef struct AutoFiniteDifferences{T} <: AbstractFiniteDifferencesMode
    fdm::T = nothing
end

struct AutoForwardDiff{chunksize,T} <: AbstractForwardMode
    tag::T
end

function AutoForwardDiff(; chunksize = nothing, tag = nothing)
    AutoForwardDiff{chunksize, typeof(tag)}(tag)
end

struct AutoPolyesterForwardDiff{chunksize} <: AbstractForwardMode
end

function AutoPolyesterForwardDiff(; chunksize = nothing)
    AutoPolyesterForwardDiff{chunksize}()
end

Base.@kwdef struct AutoReverseDiff <: AbstractReverseMode
    compile::Bool = false
end

struct AutoZygote <: AbstractReverseMode end
struct AutoSparseZygote <: AbstractSparseReverseMode end

Base.@kwdef struct AutoEnzyme{M} <: AbstractADType
    mode::M = nothing
end

struct AutoTracker <: AbstractReverseMode end

Base.@kwdef struct AutoModelingToolkit <: AbstractSymbolicDifferentiationMode
    obj_sparse::Bool = false
    cons_sparse::Bool = false
end

struct AutoSparseFiniteDiff <: AbstractSparseFiniteDifferences end

struct AutoSparseForwardDiff{chunksize,T} <: AbstractSparseForwardMode
    tag::T
end

function AutoSparseForwardDiff(; chunksize = nothing, tag = nothing)
    AutoSparseForwardDiff{chunksize, typeof(tag)}(tag)
end

struct AutoSparsePolyesterForwardDiff{chunksize} <: AbstractSparseForwardMode
end

function AutoSparsePolyesterForwardDiff(; chunksize = nothing)
    AutoSparsePolyesterForwardDiff{chunksize}()
end

Base.@kwdef struct AutoSparseReverseDiff <: AbstractSparseReverseMode 
    compile::Bool = false
end

export AutoChainRules,
       AutoFiniteDiff,
       AutoFiniteDifferences,
       AutoForwardDiff,
       AutoReverseDiff,
       AutoZygote,
       AutoEnzyme,
       AutoTracker,
       AutoModelingToolkit,
       AutoSparseFiniteDiff,
       AutoSparseForwardDiff,
       AutoSparseZygote,
       AutoSparseReverseDiff,
       AutoPolyesterForwardDiff,
       AutoSparsePolyesterForwardDiff
end
