using ADTypes
using ADTypes: write_ad, read_ad
using JSON3
using SparseMatrixColorings
using StructTypes
using Test

# ── Helper: round-trip through write_ad / read_ad ─────────────────────────────

function roundtrip(ad)
    return read_ad(write_ad(ad))
end

# ── Type discriminator in write_ad output ─────────────────────────────────────

@testset "write_ad includes type key" begin
    for (ad, expected_type) in [
        (AutoDiffractor(),          "AutoDiffractor"),
        (AutoFastDifferentiation(), "AutoFastDifferentiation"),
        (AutoSymbolics(),           "AutoSymbolics"),
        (AutoTracker(),             "AutoTracker"),
        (AutoZygote(),              "AutoZygote"),
        (NoAutoDiff(),              "NoAutoDiff"),
    ]
        json = write_ad(ad)
        obj = JSON3.read(json)
        @test obj[:type] == expected_type
    end
end

@testset "write_ad AutoSparse includes type keys at every level" begin
    ad = AutoSparse(AutoZygote())
    obj = JSON3.read(write_ad(ad))
    @test obj[:type]                           == "AutoSparse"
    @test obj[:dense_ad][:type]                == "AutoZygote"
    @test obj[:sparsity_detector][:type]       == "NoSparsityDetector"
    @test obj[:coloring_algorithm][:type]      == "NoColoringAlgorithm"
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
    @test rt.dense_ad              isa AutoZygote
    @test rt.sparsity_detector     isa NoSparsityDetector
    @test rt.coloring_algorithm    isa NoColoringAlgorithm

    ad2 = AutoSparse(AutoTracker(); sparsity_detector=NoSparsityDetector(),
                                    coloring_algorithm=NoColoringAlgorithm())
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
    @test read_ad("""{"type":"AutoZygote"}""")              isa AutoZygote
    @test read_ad("""{"type":"AutoTracker"}""")             isa AutoTracker
    @test read_ad("""{"type":"AutoDiffractor"}""")          isa AutoDiffractor
    @test read_ad("""{"type":"AutoFastDifferentiation"}""") isa AutoFastDifferentiation
    @test read_ad("""{"type":"AutoSymbolics"}""")           isa AutoSymbolics
    @test read_ad("""{"type":"NoAutoDiff"}""")              isa NoAutoDiff

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
    @test ad.dense_ad           isa AutoZygote
    @test ad.sparsity_detector  isa NoSparsityDetector
    @test ad.coloring_algorithm isa NoColoringAlgorithm
end

# ── GreedyColoringAlgorithm serialization ────────────────────────────────────

@testset "write_ad AutoSparse with GreedyColoringAlgorithm" begin
    ad = AutoSparse(AutoZygote(); coloring_algorithm=GreedyColoringAlgorithm(LargestFirst()))
    obj = JSON3.read(write_ad(ad))
    @test obj[:coloring_algorithm][:type]             == "GreedyColoringAlgorithm"
    @test obj[:coloring_algorithm][:decompression]    == "direct"
    @test obj[:coloring_algorithm][:postprocessing]   == false
    @test obj[:coloring_algorithm][:orders][1][:type] == "LargestFirst"
end

@testset "round-trip AutoSparse with GreedyColoringAlgorithm" begin
    for order in [NaturalOrder(), LargestFirst(), IncidenceDegree()]
        ad = AutoSparse(AutoZygote(); coloring_algorithm=GreedyColoringAlgorithm(order))
        rt = roundtrip(ad)
        @test rt.coloring_algorithm isa GreedyColoringAlgorithm
        @test rt.coloring_algorithm.orders[1] isa typeof(order)
        @test rt.coloring_algorithm.postprocessing == false
    end

    # postprocessing=true survives the round-trip
    ad = AutoSparse(AutoZygote(); coloring_algorithm=GreedyColoringAlgorithm(; postprocessing=true))
    rt = roundtrip(ad)
    @test rt.coloring_algorithm.postprocessing == true
end

@testset "read_ad AutoSparse with GreedyColoringAlgorithm from hand-written JSON" begin
    json = """
    {
        "type": "AutoSparse",
        "dense_ad":           {"type": "AutoZygote"},
        "sparsity_detector":  {"type": "NoSparsityDetector"},
        "coloring_algorithm": {
            "type":           "GreedyColoringAlgorithm",
            "decompression":  "direct",
            "orders":         [{"type": "LargestFirst"}],
            "postprocessing": false
        }
    }
    """
    ad = read_ad(json)
    @test ad isa AutoSparse
    @test ad.dense_ad                         isa AutoZygote
    @test ad.sparsity_detector                isa NoSparsityDetector
    @test ad.coloring_algorithm               isa GreedyColoringAlgorithm
    @test ad.coloring_algorithm.orders[1]     isa LargestFirst
    @test ad.coloring_algorithm.postprocessing == false
end
