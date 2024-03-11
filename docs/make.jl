using Documenter
using ADTypes

makedocs(
    sitename = "ADTypes",
    format = Documenter.HTML(),
    modules = [ADTypes]
)

deploydocs(
    repo = "https://github.com/SciML/ADTypes.jl.git"
)
