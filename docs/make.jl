using PMParameterizedSensitivity
using Documenter

DocMeta.setdocmeta!(PMParameterizedSensitivity, :DocTestSetup, :(using PMParameterizedSensitivity); recursive=true)

makedocs(;
    modules=[PMParameterizedSensitivity],
    authors="Timothy Knab",
    repo="https://github.com/timknab/PMParameterizedSensitivity.jl/blob/{commit}{path}#{line}",
    sitename="PMParameterizedSensitivity.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://timknab.github.io/PMParameterizedSensitivity.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/timknab/PMParameterizedSensitivity.jl",
    devbranch="main",
)
