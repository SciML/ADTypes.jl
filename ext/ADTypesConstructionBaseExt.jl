module ADTypesConstructionBaseExt

using ADTypes: AutoEnzyme, AutoForwardDiff, AutoPolyesterForwardDiff
using ConstructionBase: ConstructionBase

struct InternalAutoEnzymeReconstructor{A, R, C} end

function InternalAutoEnzymeReconstructor{A, R, C}(mode::M) where {M, A, R, C}
    AutoEnzyme{M, A, R, C}(mode)
end

function ConstructionBase.constructorof(::Type{<:AutoEnzyme{M, A, R, C}}) where {M, A, R, C}
    return InternalAutoEnzymeReconstructor{A, R, C}
end

function ConstructionBase.constructorof(::Type{<:AutoForwardDiff{chunksize}}) where {chunksize}
    return AutoForwardDiff{chunksize}
end

function ConstructionBase.constructorof(::Type{<:AutoPolyesterForwardDiff{chunksize}}) where {chunksize}
    return AutoPolyesterForwardDiff{chunksize}
end

end
