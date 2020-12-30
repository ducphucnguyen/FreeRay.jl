using Documenter, FreeRay

makedocs(sitename="FreeRay")


deploydocs(
    repo    = "github.com/ducphucnguyen/FreeRay.jl.git",
    target  = "build",
    deps    = nothing,
    make    = nothing
)

#serve(dir="docs/build")
