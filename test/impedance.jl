include("src/impedance/impedance.jl")
#include("src/constants.jl")
#using .constants
#include("docs/make.jl")


using .impedance

#f = 10; σ = 200_000; α = 5; Ω = 0.5; q = 1.3; sf=0.85; σs=0.3; s̄=46*10^-7

f = 1000         # Hz, frequency
σ = 200_0     # Pa.s.m-2, flow resistivity
Ω = 0.5         # porosity

Zc1 = impedanceM1(f,σ)      # tested!

Zc2 = impedanceM2(f,σ)      # tested!

Zc3 = impedanceM3(f,σ,Ω)    # tested!

Zc4 = impedanceM4(f,σ,Ω)    # tested!

Zc5 = impedanceM5(f,σ,Ω)    # tested!

Zc6 = impedanceM6(f,σ,Ω)    # tested!

Zc7 = impedanceM7(f,σ,Ω)    # tested!

Zc8 = impedanceM8(f,σ,Ω)    # tested!

Zc9b = impedanceM9b(f,σ,Ω)
