using Documenter
using ADTypes

makedocs(
    sitename = "ADTypes",
    format = Documenter.HTML(),
    modules = [ADTypes],
    doctest = true,
    checkdocs = :exports,
)

deploydocs(
    repo = "github.com/SciML/ADTypes.jl.git"
)
