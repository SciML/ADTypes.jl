module ADTypesConstructionBaseExt

using ADTypes: AutoEnzyme, AutoForwardDiff, AutoPolyesterForwardDiff
using ConstructionBase: ConstructionBase

struct InternalAutoEnzymeReconstructor{A, C} end

function InternalAutoEnzymeReconstructor{A, C}(mode::M) where {M, A, C}
    AutoEnzyme{M, A, C}(mode)
end

function ConstructionBase.constructorof(::Type{<:AutoEnzyme{M, A, C}}) where {M, A, C}
    return InternalAutoEnzymeReconstructor{A, C}
end

function ConstructionBase.constructorof(::Type{<:AutoForwardDiff{chunksize}}) where {chunksize}
    return AutoForwardDiff{chunksize}
end

function ConstructionBase.constructorof(::Type{<:AutoPolyesterForwardDiff{chunksize}}) where {chunksize}
    return AutoPolyesterForwardDiff{chunksize}
end

end
