module ADTypesConstructionBaseExt

using ADTypes: AutoEnzyme, AutoForwardDiff, AutoPolyesterForwardDiff
using ConstructionBase: ConstructionBase

function ConstructionBase.constructorof(::Type{<:AutoEnzyme{M, A}}) where {M, A}
    return AutoEnzyme{A}
end

function ConstructionBase.constructorof(::Type{<:AutoForwardDiff{chunksize}}) where {chunksize}
    return AutoForwardDiff{chunksize}
end

function ConstructionBase.constructorof(::Type{<:AutoPolyesterForwardDiff{chunksize}}) where {chunksize}
    return AutoPolyesterForwardDiff{chunksize}
end

end
