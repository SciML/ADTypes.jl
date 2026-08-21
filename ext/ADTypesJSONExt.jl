module ADTypesJSONExt

using ADTypes
using JSON
using StructUtils

ADTypes.write_ad(ad::ADTypes.AbstractADType) = JSON.json(ad)
ADTypes.read_ad(json::AbstractString) = JSON.parse(json, ADTypes.AbstractADType)

# ── JSON-specific make methods ────────────────────────────────────────────────
#
# These specialize on JSON.JSONStyle (a supertype of the JSONReadStyle used by
# JSON.parse), winning over the generic StructUtils.StructStyle methods in
# ADTypesStructUtilsExt.  Each method returns JSON.skip(source) as the state,
# giving JSON._parse the correct end-of-object position for checkendpos.

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoForwardDiff}, source)
    chunksize = source["chunksize"][]
    return ADTypes.AutoForwardDiff{chunksize}(nothing), JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoReverseDiff}, source)
    compile = source["compile"][]
    return ADTypes.AutoReverseDiff(; compile = compile), JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoTaylorDiff}, source)
    order = source["order"][]
    return ADTypes.AutoTaylorDiff{order}(), JSON.skip(source)
end

function StructUtils.make(
        style::JSON.JSONStyle, ::Type{<:ADTypes.AutoHyperHessians}, source
    )
    chunksize = source["chunksize"][]
    simd = source["simd"][]
    jet = source["jet"][]
    return ADTypes.AutoHyperHessians{chunksize}(simd, jet), JSON.skip(source)
end

function StructUtils.make(
        style::JSON.JSONStyle, ::Type{<:ADTypes.AutoPolyesterForwardDiff}, source
    )
    chunksize = source["chunksize"][]
    return ADTypes.AutoPolyesterForwardDiff{chunksize}(nothing), JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoGTPSA}, source)
    return ADTypes.AutoGTPSA(), JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoMooncake}, source)
    return ADTypes.AutoMooncake(), JSON.skip(source)
end

function StructUtils.make(
        style::JSON.JSONStyle, ::Type{<:ADTypes.AutoMooncakeForward}, source
    )
    return ADTypes.AutoMooncakeForward(), JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{ADTypes.AutoTapir}, source)
    safe_mode = source["safe_mode"][]
    return ADTypes.AutoTapir(safe_mode), JSON.skip(source)  # positional: avoids depwarn
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoFiniteDiff}, source)
    fdtype = Val(Symbol(source["fdtype"][]))
    fdjtype = Val(Symbol(source["fdjtype"][]))
    fdhtype = Val(Symbol(source["fdhtype"][]))
    relstep = source["relstep"][]
    absstep = source["absstep"][]
    dir = source["dir"][]
    return ADTypes.AutoFiniteDiff(; fdtype, fdjtype, fdhtype, relstep, absstep, dir),
        JSON.skip(source)
end

function StructUtils.make(style::JSON.JSONStyle, ::Type{<:ADTypes.AutoSparse}, source)
    dense_ad = StructUtils.make(style, ADTypes.AbstractADType, source["dense_ad"])[1]
    sparsity_detector = StructUtils.make(
        style, ADTypes.AbstractSparsityDetector, source["sparsity_detector"]
    )[1]
    coloring_algorithm = StructUtils.make(
        style, ADTypes.AbstractColoringAlgorithm, source["coloring_algorithm"]
    )[1]
    return ADTypes.AutoSparse(dense_ad; sparsity_detector, coloring_algorithm),
        JSON.skip(source)
end

end # module ADTypesJSONExt
