using ADTypes, BenchmarkTools
using SparseArrays

const SUITE = BenchmarkGroup()

# =============================================================================
# Backend construction
# =============================================================================

SUITE["construct"] = BenchmarkGroup()

SUITE["construct"]["AutoForwardDiff"] = @benchmarkable AutoForwardDiff()
SUITE["construct"]["AutoFiniteDiff"] = @benchmarkable AutoFiniteDiff()
SUITE["construct"]["AutoZygote"] = @benchmarkable AutoZygote()
SUITE["construct"]["AutoEnzyme"] = @benchmarkable AutoEnzyme()
SUITE["construct"]["AutoForwardDiff_chunk"] = @benchmarkable AutoForwardDiff(
    chunksize = 8
)
SUITE["construct"]["AutoSparse"] = @benchmarkable AutoSparse(AutoForwardDiff())

# =============================================================================
# Interface queries
# =============================================================================

SUITE["interface"] = BenchmarkGroup()

afd = AutoForwardDiff()
asp = AutoSparse(AutoForwardDiff())

SUITE["interface"]["mode"] = @benchmarkable ADTypes.mode($afd)
SUITE["interface"]["dense_ad"] = @benchmarkable ADTypes.dense_ad($asp)
SUITE["interface"]["dense_ad_dense"] = @benchmarkable ADTypes.dense_ad($afd)

# =============================================================================
# Sparsity detection (known-pattern path)
# =============================================================================

SUITE["sparsity"] = BenchmarkGroup()

N = 100
f_jac(x) = x .* x
x_vec = ones(N)
J_pattern = sparse(ones(N, N))
detector = ADTypes.KnownJacobianSparsityDetector(J_pattern)

SUITE["sparsity"]["construct_detector"] = @benchmarkable ADTypes.KnownJacobianSparsityDetector(
    $J_pattern
)
SUITE["sparsity"]["jacobian_sparsity"] = @benchmarkable jacobian_sparsity(
    $f_jac, $x_vec, $detector
)
