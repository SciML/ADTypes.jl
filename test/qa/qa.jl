using SciMLTesting, ADTypes, Test
using JET

# Aqua and ExplicitImports are SciMLTesting deps, so they are not imported here.
# Aqua is still listed in this env's `[deps]` (not ExplicitImports): Aqua's ambiguity
# check spawns a worker subprocess that runs a bare `using Aqua` against the active
# project, which only resolves if Aqua is a *direct* dep — a transitive (manifest-only)
# Aqua makes that worker error with "Package Aqua not found in current path".
run_qa(
    ADTypes;
    api_docs_kwargs = (; rendered = true),
    aqua_kwargs = (; deps_compat = (; check_extras = false)),
    jet_kwargs = (; target_defined_modules = true),
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
