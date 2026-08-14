using ADTypes
using ADTypes: write_ad, read_ad, NoSparsityDetector, NoColoringAlgorithm
using EnzymeCore: EnzymeCore
using JSON3
using StructTypes
using Test

# ── Helper: round-trip through write_ad / read_ad ─────────────────────────────

function roundtrip(ad)
    return read_ad(write_ad(ad))
end

# ── Type discriminator in write_ad output ─────────────────────────────────────

@testset "write_ad includes type key" begin
    for (ad, expected_type) in [
            (AutoDiffractor(), "AutoDiffractor"),
            (AutoFastDifferentiation(), "AutoFastDifferentiation"),
            (AutoSymbolics(), "AutoSymbolics"),
            (AutoTracker(), "AutoTracker"),
            (AutoZygote(), "AutoZygote"),
            (NoAutoDiff(), "NoAutoDiff"),
        ]
        json = write_ad(ad)
        obj = JSON3.read(json)
        @test obj[:type] == expected_type
    end
end

@testset "write_ad AutoSparse includes type keys at every level" begin
    ad = AutoSparse(AutoZygote())
    obj = JSON3.read(write_ad(ad))
    @test obj[:type] == "AutoSparse"
    @test obj[:dense_ad][:type] == "AutoZygote"
    @test obj[:sparsity_detector][:type] == "NoSparsityDetector"
    @test obj[:coloring_algorithm][:type] == "NoColoringAlgorithm"
end

# ── round-trip: write_ad → read_ad ────────────────────────────────────────────

@testset "round-trip empty backends" begin
    for ad in [
            AutoDiffractor(),
            AutoFastDifferentiation(),
            AutoSymbolics(),
            AutoTracker(),
            AutoZygote(),
            NoAutoDiff(),
        ]
        @test roundtrip(ad) isa typeof(ad)
    end
end

@testset "round-trip AutoSparse" begin
    ad = AutoSparse(AutoZygote())
    rt = roundtrip(ad)
    @test rt isa AutoSparse
    @test rt.dense_ad isa AutoZygote
    @test rt.sparsity_detector isa NoSparsityDetector
    @test rt.coloring_algorithm isa NoColoringAlgorithm

    ad2 = AutoSparse(
        AutoTracker(); sparsity_detector = NoSparsityDetector(),
        coloring_algorithm = NoColoringAlgorithm()
    )
    rt2 = roundtrip(ad2)
    @test rt2.dense_ad isa AutoTracker
end

# ── round-trip through an abstract-typed struct field ─────────────────────────
# The type discriminator only appears automatically when JSON3 is writing
# through a field declared as an abstract type.  This verifies the
# StructTypes.AbstractType() registrations work end-to-end.

struct _TestConfig
    backend::AbstractADType
end
StructTypes.StructType(::Type{_TestConfig}) = StructTypes.Struct()

@testset "round-trip via abstract-typed struct field" begin
    for ad in [
            AutoDiffractor(),
            AutoFastDifferentiation(),
            AutoSymbolics(),
            AutoTracker(),
            AutoZygote(),
            AutoSparse(AutoZygote()),
        ]
        cfg = _TestConfig(ad)
        json = JSON3.write(cfg)
        recovered = JSON3.read(json, _TestConfig)
        @test recovered.backend isa typeof(ad)
    end
end

# ── read_ad from hand-written JSON (Python interop simulation) ─────────────────

@testset "read_ad from hand-written JSON" begin
    @test read_ad("""{"type":"AutoZygote"}""") isa AutoZygote
    @test read_ad("""{"type":"AutoTracker"}""") isa AutoTracker
    @test read_ad("""{"type":"AutoDiffractor"}""") isa AutoDiffractor
    @test read_ad("""{"type":"AutoFastDifferentiation"}""") isa AutoFastDifferentiation
    @test read_ad("""{"type":"AutoSymbolics"}""") isa AutoSymbolics
    @test read_ad("""{"type":"NoAutoDiff"}""") isa NoAutoDiff

    sparse_json = """
    {
        "type": "AutoSparse",
        "dense_ad":             {"type": "AutoZygote"},
        "sparsity_detector":    {"type": "NoSparsityDetector"},
        "coloring_algorithm":   {"type": "NoColoringAlgorithm"}
    }
    """
    ad = read_ad(sparse_json)
    @test ad isa AutoSparse
    @test ad.dense_ad isa AutoZygote
    @test ad.sparsity_detector isa NoSparsityDetector
    @test ad.coloring_algorithm isa NoColoringAlgorithm
end

# ── AutoForwardDiff ───────────────────────────────────────────────────────────

@testset "AutoForwardDiff JSON structure" begin
    obj = JSON3.read(write_ad(AutoForwardDiff()))
    @test obj[:type] == "AutoForwardDiff"
    @test isnothing(obj[:chunksize])

    obj2 = JSON3.read(write_ad(AutoForwardDiff(; chunksize = 8)))
    @test obj2[:type] == "AutoForwardDiff"
    @test obj2[:chunksize] == 8
end

@testset "AutoForwardDiff round-trip" begin
    @test roundtrip(AutoForwardDiff()) isa AutoForwardDiff{nothing, Nothing}
    @test roundtrip(AutoForwardDiff(; chunksize = 4)) isa AutoForwardDiff{4, Nothing}
end

@testset "AutoForwardDiff from hand-written JSON" begin
    @test read_ad("""{"type":"AutoForwardDiff","chunksize":null}""") isa AutoForwardDiff{nothing}
    @test read_ad("""{"type":"AutoForwardDiff","chunksize":6}""") isa AutoForwardDiff{6}
end

# ── AutoReverseDiff ───────────────────────────────────────────────────────────

@testset "AutoReverseDiff JSON structure" begin
    obj = JSON3.read(write_ad(AutoReverseDiff()))
    @test obj[:type] == "AutoReverseDiff"
    @test obj[:compile] == false

    obj2 = JSON3.read(write_ad(AutoReverseDiff(; compile = true)))
    @test obj2[:compile] == true
end

@testset "AutoReverseDiff round-trip" begin
    @test roundtrip(AutoReverseDiff()) isa AutoReverseDiff{false}
    @test roundtrip(AutoReverseDiff(; compile = true)) isa AutoReverseDiff{true}
    @test roundtrip(AutoReverseDiff(; compile = Val(true))) isa AutoReverseDiff{true}
end

@testset "AutoReverseDiff from hand-written JSON" begin
    @test read_ad("""{"type":"AutoReverseDiff","compile":false}""") isa AutoReverseDiff{false}
    @test read_ad("""{"type":"AutoReverseDiff","compile":true}""") isa AutoReverseDiff{true}
end

# ── AutoEnzyme ────────────────────────────────────────────────────────────────

@testset "AutoEnzyme JSON structure" begin
    obj = JSON3.read(write_ad(AutoEnzyme()))
    @test obj[:type] == "AutoEnzyme"
    @test isnothing(obj[:mode])

    obj2 = JSON3.read(write_ad(AutoEnzyme(mode = EnzymeCore.Forward)))
    @test obj2[:mode] == "Forward"

    obj3 = JSON3.read(write_ad(AutoEnzyme(mode = EnzymeCore.Reverse)))
    @test obj3[:mode] == "Reverse"
end

@testset "AutoEnzyme round-trip" begin
    rt = roundtrip(AutoEnzyme())
    @test isnothing(rt.mode)

    rt2 = roundtrip(AutoEnzyme(mode = EnzymeCore.Forward))
    @test rt2.mode isa EnzymeCore.ForwardMode

    rt3 = roundtrip(AutoEnzyme(mode = EnzymeCore.Reverse))
    @test rt3.mode isa EnzymeCore.ReverseMode
end

@testset "AutoEnzyme from hand-written JSON" begin
    @test read_ad("""{"type":"AutoEnzyme","mode":null}""") isa AutoEnzyme{Nothing}
    ad = read_ad("""{"type":"AutoEnzyme","mode":"Forward"}""")
    @test ad.mode isa EnzymeCore.ForwardMode
    ad2 = read_ad("""{"type":"AutoEnzyme","mode":"Reverse"}""")
    @test ad2.mode isa EnzymeCore.ReverseMode
end

# ── AutoTaylorDiff ────────────────────────────────────────────────────────────

@testset "AutoTaylorDiff JSON structure" begin
    obj = JSON3.read(write_ad(AutoTaylorDiff()))
    @test obj[:type] == "AutoTaylorDiff"
    @test obj[:order] == 1

    obj2 = JSON3.read(write_ad(AutoTaylorDiff(; order = 3)))
    @test obj2[:order] == 3
end

@testset "AutoTaylorDiff round-trip" begin
    @test roundtrip(AutoTaylorDiff()) isa AutoTaylorDiff{1}
    @test roundtrip(AutoTaylorDiff(; order = 5)) isa AutoTaylorDiff{5}
end

@testset "AutoTaylorDiff from hand-written JSON" begin
    @test read_ad("""{"type":"AutoTaylorDiff","order":1}""") isa AutoTaylorDiff{1}
    @test read_ad("""{"type":"AutoTaylorDiff","order":4}""") isa AutoTaylorDiff{4}
end

# ── AutoHyperHessians ─────────────────────────────────────────────────────────

@testset "AutoHyperHessians JSON structure" begin
    obj = JSON3.read(write_ad(AutoHyperHessians()))
    @test obj[:type] == "AutoHyperHessians"
    @test isnothing(obj[:chunksize])
    @test obj[:simd] == false
    @test obj[:jet] == false

    obj2 = JSON3.read(write_ad(AutoHyperHessians(; chunksize = 4, simd = true, jet = true)))
    @test obj2[:chunksize] == 4
    @test obj2[:simd] == true
    @test obj2[:jet] == true
end

@testset "AutoHyperHessians round-trip" begin
    rt = roundtrip(AutoHyperHessians())
    @test rt isa AutoHyperHessians{nothing}
    @test rt.simd == false
    @test rt.jet == false

    rt2 = roundtrip(AutoHyperHessians(; chunksize = 8, simd = true, jet = false))
    @test rt2 isa AutoHyperHessians{8}
    @test rt2.simd == true
    @test rt2.jet == false
end

@testset "AutoHyperHessians from hand-written JSON" begin
    ad = read_ad("""{"type":"AutoHyperHessians","chunksize":null,"simd":false,"jet":false}""")
    @test ad isa AutoHyperHessians{nothing}
    @test ad.simd == false

    ad2 = read_ad("""{"type":"AutoHyperHessians","chunksize":4,"simd":true,"jet":true}""")
    @test ad2 isa AutoHyperHessians{4}
    @test ad2.simd == true
    @test ad2.jet == true
end

# ── AutoPolyesterForwardDiff ──────────────────────────────────────────────────

@testset "AutoPolyesterForwardDiff JSON structure" begin
    obj = JSON3.read(write_ad(AutoPolyesterForwardDiff()))
    @test obj[:type] == "AutoPolyesterForwardDiff"
    @test isnothing(obj[:chunksize])

    obj2 = JSON3.read(write_ad(AutoPolyesterForwardDiff(; chunksize = 8)))
    @test obj2[:chunksize] == 8
end

@testset "AutoPolyesterForwardDiff round-trip" begin
    rt = roundtrip(AutoPolyesterForwardDiff())
    @test rt isa AutoPolyesterForwardDiff{nothing, Nothing}

    rt2 = roundtrip(AutoPolyesterForwardDiff(; chunksize = 4))
    @test rt2 isa AutoPolyesterForwardDiff{4, Nothing}
end

@testset "AutoPolyesterForwardDiff from hand-written JSON" begin
    @test read_ad("""{"type":"AutoPolyesterForwardDiff","chunksize":null}""") isa AutoPolyesterForwardDiff{nothing}
    @test read_ad("""{"type":"AutoPolyesterForwardDiff","chunksize":6}""") isa AutoPolyesterForwardDiff{6}
end

# ── AutoGTPSA ─────────────────────────────────────────────────────────────────

@testset "AutoGTPSA JSON structure" begin
    obj = JSON3.read(write_ad(AutoGTPSA()))
    @test obj[:type] == "AutoGTPSA"
end

@testset "AutoGTPSA round-trip" begin
    @test roundtrip(AutoGTPSA()) isa AutoGTPSA{Nothing}
end

@testset "AutoGTPSA from hand-written JSON" begin
    @test read_ad("""{"type":"AutoGTPSA"}""") isa AutoGTPSA{Nothing}
end

# ── AutoMooncake ──────────────────────────────────────────────────────────────

@testset "AutoMooncake JSON structure" begin
    obj = JSON3.read(write_ad(AutoMooncake()))
    @test obj[:type] == "AutoMooncake"
end

@testset "AutoMooncake round-trip" begin
    @test roundtrip(AutoMooncake()) isa AutoMooncake{Nothing}
end

@testset "AutoMooncake from hand-written JSON" begin
    @test read_ad("""{"type":"AutoMooncake"}""") isa AutoMooncake{Nothing}
end

# ── AutoMooncakeForward ───────────────────────────────────────────────────────

@testset "AutoMooncakeForward JSON structure" begin
    obj = JSON3.read(write_ad(AutoMooncakeForward()))
    @test obj[:type] == "AutoMooncakeForward"
end

@testset "AutoMooncakeForward round-trip" begin
    @test roundtrip(AutoMooncakeForward()) isa AutoMooncakeForward{Nothing}
end

@testset "AutoMooncakeForward from hand-written JSON" begin
    @test read_ad("""{"type":"AutoMooncakeForward"}""") isa AutoMooncakeForward{Nothing}
end

# ── AutoTapir (deprecated) ────────────────────────────────────────────────────

@testset "AutoTapir JSON structure" begin
    obj = JSON3.read(write_ad(AutoTapir(false)))  # positional: avoids depwarn
    @test obj[:type] == "AutoTapir"
    @test obj[:safe_mode] == false

    obj2 = JSON3.read(write_ad(AutoTapir(true)))
    @test obj2[:safe_mode] == true
end

@testset "AutoTapir round-trip" begin
    @test roundtrip(AutoTapir(false)).safe_mode == false
    @test roundtrip(AutoTapir(true)).safe_mode == true
end

@testset "AutoTapir from hand-written JSON" begin
    ad = read_ad("""{"type":"AutoTapir","safe_mode":false}""")
    @test ad isa AutoTapir
    @test ad.safe_mode == false
end

# ── AutoFiniteDiff ────────────────────────────────────────────────────────────

@testset "AutoFiniteDiff JSON structure" begin
    obj = JSON3.read(write_ad(AutoFiniteDiff()))
    @test obj[:type] == "AutoFiniteDiff"
    @test obj[:fdtype] == "forward"
    @test obj[:fdjtype] == "forward"
    @test obj[:fdhtype] == "hcentral"
    @test isnothing(obj[:relstep])
    @test isnothing(obj[:absstep])
    @test obj[:dir] == true
end

@testset "AutoFiniteDiff round-trip" begin
    rt = roundtrip(AutoFiniteDiff())
    @test rt isa AutoFiniteDiff
    @test rt.fdtype == Val(:forward)
    @test rt.fdjtype == Val(:forward)
    @test rt.fdhtype == Val(:hcentral)
    @test isnothing(rt.relstep)
    @test isnothing(rt.absstep)
    @test rt.dir == true

    rt2 = roundtrip(AutoFiniteDiff(; fdtype = Val(:central), relstep = 1.0e-5, absstep = 1.0e-8))
    @test rt2.fdtype == Val(:central)
    @test rt2.relstep ≈ 1.0e-5
    @test rt2.absstep ≈ 1.0e-8
end

@testset "AutoFiniteDiff from hand-written JSON" begin
    ad = read_ad("""{"type":"AutoFiniteDiff","fdtype":"forward","fdjtype":"forward","fdhtype":"hcentral","relstep":null,"absstep":null,"dir":true}""")
    @test ad isa AutoFiniteDiff
    @test ad.fdtype == Val(:forward)
    @test ad.fdhtype == Val(:hcentral)
    @test isnothing(ad.relstep)
    @test ad.dir == true
end

# ── AutoReactant ──────────────────────────────────────────────────────────────

@testset "AutoReactant JSON structure" begin
    obj = JSON3.read(write_ad(AutoReactant()))
    @test obj[:type] == "AutoReactant"
    @test obj[:mode][:type] == "AutoEnzyme"
    @test isnothing(obj[:mode][:mode])
end

@testset "AutoReactant round-trip" begin
    rt = roundtrip(AutoReactant())
    @test rt isa AutoReactant
    @test rt.mode isa AutoEnzyme

    rt2 = roundtrip(AutoReactant(; mode = AutoEnzyme(mode = EnzymeCore.Forward)))
    @test rt2.mode.mode isa EnzymeCore.ForwardMode
end

@testset "AutoReactant from hand-written JSON" begin
    ad = read_ad("""{"type":"AutoReactant","mode":{"type":"AutoEnzyme","mode":null}}""")
    @test ad isa AutoReactant
    @test ad.mode isa AutoEnzyme
    @test isnothing(ad.mode.mode)
end
