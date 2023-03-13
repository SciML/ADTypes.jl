module ADTypes

"""
Base type for AD choices.
"""
abstract type AbstractADType end

struct AutoFiniteDiff{T1, T2, T3} <: AbstractADType
    fdtype::T1
    fdjtype::T2
    fdhtype::T3
end

function AutoFiniteDiff(; fdtype = Val(:forward), fdjtype = fdtype,
                        fdhtype = Val(:hcentral))
    AutoFiniteDiff(fdtype, fdjtype, fdhtype)
end

struct AutoForwardDiff{chunksize} <: AbstractADType end

function AutoForwardDiff(chunksize = nothing)
    AutoForwardDiff{chunksize}()
end

struct AutoReverseDiff <: AbstractADType
    compile::Bool
end

AutoReverseDiff(; compile = false) = AutoReverseDiff(compile)

struct AutoZygote <: AbstractADType end

struct AutoEnzyme <: AbstractADType end

struct AutoTracker <: AbstractADType end

export AutoFiniteDiff, AutoForwardDiff, AutoReverseDiff, AutoZygote, AutoEnzyme, AutoTracker
end
