module FreeRay

# using Julia package
using Parsers, DataFrames, Plots, SpecialFunctions

# Model utilities
include("utils.jl")

# Core modules
include("geometry.jl")
include("boundary.jl")
include("atmosphere.jl")
include("options.jl")
include("impcoeff.jl")
include("impedance.jl")
include("windprofile.jl")



include("environment.jl")
include("plotray.jl")
include("PlotShd.jl")
include("plottlr.jl")





end
