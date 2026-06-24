using ADTypes
using Aqua: Aqua
using ExplicitImports: ExplicitImports
using JET: JET
using SciMLTesting: run_qa
using Test

run_qa(
    ADTypes;
    Aqua = Aqua,
    aqua_kwargs = (; deps_compat = (; check_extras = false)),
    JET = JET,
    jet = true,
    jet_kwargs = (; target_defined_modules = true),
    ExplicitImports = ExplicitImports,
    explicit_imports = true,
    # Two unavoidable non-public `Base` names, ignored only in the public-API access
    # check (every other ExplicitImports check passes unignored):
    #   * `broadcastable` — the documented broadcasting customization hook;
    #     `Base.broadcastable(ad::AbstractADType) = Ref(ad)` makes AD choices broadcast
    #     as scalars. `Base` marks it non-public on every Julia version.
    #   * `depwarn` — `Base.depwarn` is the only way to emit a deprecation warning, and
    #     it is non-public on the LTS (1.10). It became public in Base on 1.11+, where
    #     ignoring it is a harmless no-op.
    # (`Base.Meta.isexpr` in src/compat.jl was switched off `Base.isexpr` so its access
    # resolves to the public `Base.Meta` owner and needs no ignore on any version.)
    ei_kwargs = (; all_qualified_accesses_are_public = (; ignore = (:broadcastable, :depwarn))),
)
