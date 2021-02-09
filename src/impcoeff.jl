export R_coeff, Q_coeff, impedanceM1
include("constant.jl")
#using .constant

# plan-wave reflection coefficient
"""

    R_coeff(Zc)

Calculate plan-wave reflection coefficient

# Arguments
- `Zc`: complex number, ground characteristic impedance

# Output
- `𝛹`: deg, grazing angle
- `R_mag`: coefficient magnitude
- `R_phase`: deg, phase

# Example
```julia-repl
julia> Zc = 10 + 10im
julia> 𝛹, R_mag, R_phase = R_coeff(Zc)
```

"""
function R_coeff(Zc;len::Int64=1000)
    𝛹 = range(0.0,π/2, length = len)
    R_coeff = ( sin.(𝛹) .- 1/Zc ) ./ ( sin.(𝛹) .+ 1/Zc )
    THETA = Float32.(𝛹*180/π)
    RMAG = Float32.(abs.(R_coeff))
    RPHASE = Float32.(angle.(R_coeff)*180/π)
    return THETA, RMAG, RPHASE
end


#@btime R_coeff(Zc)
#𝛹, R_mag, R_phase =   R_coeff(Zc)
#plot(𝛹,R_phase)

# spherical-wave reflection coefficient
"""


    Q_coeff(Zc,R2,f)

Calculate spherical-wave reflection coefficient

# Arguments:

- `Zc`: complex number, characteristic impedance
- `R2`: m, length of reflection ray path
- `f`: Hz, frequency

# Outputs:
- `𝛹`: deg, grazing angle
- `Q_mag`: coefficient magnitude
- `Q_phase`: deg, phase

# Example:
```julia-repl
julia> Zc = 10 + 10im
julia> 𝛹, Q_mag, Q_phase = R_coeff(Zc)
```

"""
function Q_coeff(Zc,R2,f,len=100)
    λ = c0/f
    k = 2*π/λ
    𝛹 = range(0,π/2, length = len)

    Q_coeff = randn(ComplexF64, (length(𝛹), 1))
    for i=1:length(𝛹)
        d = sqrt(1im*k*R2/2) * (1/Zc + sin(𝛹[i]))
        Fd = 1 + 1im*sqrt(π)*d*erfcx(-1im*(d))
        Q_coeff[i] = (Zc*sin(𝛹[i]) - 1 + 2*Fd) / (Zc*sin(𝛹[i]) + 1)
    end

    return Float32.(𝛹*180/π), Float32.(abs.(Q_coeff[:,1])), Float32.(angle.(Q_coeff[:,1])*180/π)

end
