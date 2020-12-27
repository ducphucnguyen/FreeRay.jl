module FreeRay

# using Julia package
using Parsers, DataFrames, Plots

# Model utilities
include("utils.jl")

# Core modules
include("geometry.jl")
include("boundary.jl")
include("atmosphere.jl")
include("options.jl")

include("environment.jl")
include("postprocess.jl")



end
