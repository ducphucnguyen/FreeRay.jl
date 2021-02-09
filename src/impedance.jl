export impedanceM1, impedanceM2, impedanceM3, impedanceM4,
        impedanceM5, impedanceM6, impedanceM7, impedanceM8,
        impedanceM9, impedanceM9b


include("constant.jl")
#using .constant

"""

        impedanceM1(f,σ)


Delany and Bazley model

Compute characteristic ground impedance with 1 input parameter

# Arguments
- `σ`: Pa.s.m-2, flow resitivity (realistic values [5x10^3 3x10^7])

# Example:
```julia-repl
julia> impedanceM1(100, 200_000)
```
---
[1]. Denaly & Bazley, Acoustical properties of fibrous absorbent materials,
Appl. Acoustisc, 1970

[2]. Attenborough, Keith, Imran Bashir, and Shahram Taherzadeh. "Outdoor ground impedance models."
The Journal of the Acoustical Society of America 129.5 (2011): 2806-2819.

"""
function impedanceM1(f,σ)
    X = f*ϱ0/σ # in Ref. [2], this equation is typo error
    Zc = 1 + 0.0571*X^(-0.754) + 1im*0.087*X^(-0.732) # Eq. (1b) Ref. [2]
    return Zc
end


"""

        impedanceM2(f,σ)

        impedanceM2(f,σ,α)


Variable prositty models

Compute characteristic ground impedance with 2 input parameters

# Arguments

- `σ`: Pa.s.m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `α`: /m, rate of porosity variation (realistic values [1 10]), defaul α = 8 m-1

# Example:
```julia-repl
julia> impedanceM2(100,200_000)
julia> impedanceM2(100, 200_000,5)
```

---
[1]. Attenborough et al., Outdoor ground impedance models EuroNoise, 2015

"""
function impedanceM2(f,σ,α::Any=8)
    # default value for α = 8m-1 as used for institutional grass (Donato, 1977, JASA)
    Zc =    (1+1im)/sqrt(π*γa*ϱ0)*sqrt(σ/f) +
            1im*c0*α/(8*π*f)
    return Zc
end


"""

        impedanceM3(f,σ,Ω)

        impedanceM3(f,σ,Ω,svor,sent)


Wilson relaxation model

Compute characteristic ground impedance with 2 input parameters

# Arguments
- `σ`: Pa.s.m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω`: prosity (realistic values [0.1 0.8]) (Table 10.1, ref. [1])

- `svor`, `sent`: shape factor, default values = 1

# Example:
```julia-repl
julia> impedanceM3(100,200_000,0.5)
```

---
[1]. Ostashev, Vladimir E., and D. Keith Wilson.
Acoustics in moving inhomogeneous media. CRC Press, 2015.

"""
function impedanceM3(f,σ,Ω, svor::Any=1,sent::Any=1)
    ω = 2π*f
    q = Ω^-0.25 # page 371
    τ0 = (2*ϱ0*q^2)/(σ*Ω) # Eq 10.53

    term1 = 2im/(ω*τ0) + 1 + 1/sqrt(1-1im*svor^2*ω*τ0)
    term2 = 1 + (γa-1)/sqrt(1 - 1im*sent^2*Npr*ω*τ0)
    Zc = (q/Ω)*(term1/term2)^0.5 # Eq 10.54

    return Zc
end


"""

        impedanceM4(f,σ,Ω)

        impedanceM4(f,σ,Ω,q)


Zwikker and Kosten model

Compute characteristic ground impedance with 3 input parameters

# Arguments

- `σ`: Pa.s.m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω`: prosity (realistic values [0.1 0.8])

- `q`: tortuosity (realistic values [1.8 1.0]), default `q` = 1.0

# Example:
```julia-repl
julia> impedanceM4(100,200_000,0.5)
julia> impedanceM4(100,200_000,0.5,1.0)
```

---
[1]. Zwikker, Cornelis, and Cornelis Willem Kosten. Sound absorbing materials. Elsevier publishing company, 1949.

[2]. Attenborough, Keith, Imran Bashir, and Shahram Taherzadeh. "Outdoor ground impedance models."
The Journal of the Acoustical Society of America 129.5 (2011): 2806-2819.

"""
function impedanceM4(f,σ,Ω,q::Any=1.0)
    # the default value for q is for soft soil
    T = q*q
    ω = 2π*f

    Zc = (1/Ω) * ( T + 1im*Ω*σ/(ω*ϱ0) )^0.5 # Eq. 2a (ref. [2])
    return Zc
end


"""

        impedanceM5(f,σ,Ω)

        impedanceM5(f,σ,Ω,q)


Taraldsen model

Compute characteristic ground impedance with 3 input parameters

# Arguments

- `σ`: Pa.s.m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω``: prosity (realistic values [0.1 0.8])

- `q`: tortuosity (realistic values [1.8 1.0]), default `q` = 1.0

# Example:
```julia-repl
julia> impedanceM5(100,200_000,0.5)
julia> impedanceM5(100,200_000,0.5,1.0)
```

---
[1]. Taraldsen, G. "The Delany-Bazley impedance model and Darcy's law."
Acta Acustica united with Acustica 91.1 (2005): 41-50.

"""
function impedanceM5(f,σ,Ω,q::Any=1.0)
    β✶ = sqrt(γa)*Ω/q
    f✶ = 1/(2π*ϱ0)*(Ω/q)*(σ/q) # Eq. 14 note √T = q
    β = β✶*(1+1im*f✶/f)^-0.5
    Zc = 1/β

    return Zc
end


"""

        impedanceM6(f,σ,Ω)

        impedanceM6(f,σ,Ω,q)


Hamet phenomenological models

Compute characteristic ground impedance with 3 input parameters

# Arguments

- `σ`: Pa.s.m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω`: prosity (realistic values [0.1 0.8])

- `q`: tortuosity (realistic values [1.8 1.0]), default `q` = 1.0

# Example:
```julia-repl
julia> impedanceM6(100,200_000,0.5)
julia> impedanceM6(100,200_000,0.5,1.0)
```

---
[1]. Bérengier, M. C., et al. "Porous road pavements: Acoustical characterization and propagation effects."
The Journal of the Acoustical Society of America 101.1 (1997): 155-162.
"""
function impedanceM6(f,σ,Ω,q::Any=1.0)

    q² = q*q
    fμ = Ω*σ/(2π*ϱ0*q²) # Eq. 19
    fθ = σ/(2π*ϱ0*Npr)  # Eq. 20
    Fμ = 1+1im*fμ/f     # Eq. 21
    Fθ = 1 + 1im*fθ/f   # Eq. 22
    Zc = (q/Ω)*Fμ^0.5*( γa - (γa-1)/Fθ )^-0.5   # Eq. 23, without ρ0c term

    return Zc
end



"""

        impedanceM7(f,σ,Ω)

        impedanceM7(f,σ,Ω,q)


Identical tortuous pores model

Compute characteristic ground impedance with 3 input parameters

# Arguments

- `σ`: Pa s m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω`: prosity (realistic values [0.1 0.8])

- `q`: tortuosity (realistic values [1.8 1.0]), default `q` = 1.0

# Example:
```julia-repl
julia> impedanceM7(100,200_000,0.5)
julia> impedanceM7(100,200_000,0.5,1.0)
```

---
[1]. Attenborough, Keith, Imran Bashir, and Shahram Taherzadeh. "Outdoor ground impedance models."
The Journal of the Acoustical Society of America 129.5 (2011): 2806-2819.

"""
function impedanceM7(f,σ,Ω,q::Any=1.0)
    ω = 2π*f
    q² = q*q # or = T
    GS(x) = 1-tanh(x*sqrt(-1im)) / (x*sqrt(-1im)) # Eq. 6e

    λ = sqrt((3*ϱ0*ω*q²)/(Ω*σ)) # Eq. 6f
    ρ_λ = ϱ0/GS(λ) # Eq. 6c
    C_λ = 1/(γa*P0) * ( γa - (γa-1)*GS(λ*sqrt(Npr)) ) # Eq. 6d

    Zc = (ϱ0*c0)^-1 * ( (q²/Ω^2)*ρ_λ/C_λ )^0.5 # Eq. 6b

    return Zc
end


"""

        impedanceM8(f,σ,Ω)

        impedanceM8(f,σ,Ω,sf)

        impedanceM8(f,σ,Ω,sf,q)


Attenborough four parameter model

Compute characteristic ground impedance with 4 input parameters

# Arguments

- `σ`: Pa s m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω`: prosity (realistic values [0.1 0.8])

- `q`: tortuosity (realistic values [1.8 1.0]), default `q` = 1.0

- `sf`: pore shape factor (realistic values [0.6 1]), default `sf` = 0.75

# Example:
```julia-repl
julia> impedanceM8(100,200_000,0.5)
julia> impedanceM8(100,200_000,0.5,0.75)
julia> impedanceM8(100,200_000,0.5,0.75,1.0)
```

---
[1]. Attenborough, Keith. "Acoustical impedance models for outdoor ground surfaces."
Journal of Sound and Vibration 99.4 (1985): 521-544.

"""
function impedanceM8(f,σ,Ω,sf::Any=0.75,q::Any=1.0)
    ω = 2π*f
    q² = q*q

    kb =    (γa*Ω)^0.5 *
            ( (4/3 - (γa-1)/γa*Npr)*q²/Ω + 1im*sf^2*σ/(ω*ϱ0) )^0.5 # Eq. 12

    Zc = ( 4*q²/(3*Ω) + 1im*sf^2*σ/(ω*ϱ0) ) / kb # Eq. 11

    return Zc
end



"""

        impedanceM9(f,s̄,Ω)

        impedanceM9(f,s̄,Ω,σs)


Horoshenkov porous media model

Compute characteristic ground impedance with 3 input parameters

# Arguments

- `s̄`: median pore size (realistic values [2 2000 μm]), this parameter linked
to flow resistivity

- `Ω`: prosity (equivalent to Ω of other models) realistics values [0.1 0.8]

- `σs`: standard deviation of pore size distribution (realistic values [0 0.5]),
default `σs` = 0.3

# Example:
```julia-repl
julia> impedanceM9(100,200*10^-6,0.5)
julia> impedanceM9(100,200*10^-6,0.5,0.3)
```

---
[1]. Horoshenkov, Kirill V., Alistair Hurrell, and Jean-Philippe Groby. "A three-parameter analytical model for the acoustical properties of porous media."
The Journal of the Acoustical Society of America 145.4 (2019): 2512-2517.
"""
function impedanceM9(f,s̄,Ω,σs::Any=0.3)
    𝜙 = Ω # for consistent with original notations (ref. [1])

    ω = 2π*f
    α∞ = exp( 4*(σs*log(2))^2 ) # tourtuosity See Eq. 12

    θρ1 = 1/3
    θρ2 = exp( -1/2*(σs*log(2))^2 ) / sqrt(2)
    θρ3 = θρ1/θρ2

    σ = 8*η0*α∞ / (s̄^2*𝜙) * exp( 6*(σs*log(2))^2 )    # Eq. 15
    σ′ = 8*η0*α∞ / (s̄^2*𝜙) * exp( -6*(σs*log(2))^2 )  # Eq. 18

    ϵρ = sqrt( -1im*ω*ϱ0*α∞/(𝜙*σ) )
    F̃ρ = (1 + θρ3*ϵρ + θρ1*ϵρ^2) / (1 + θρ3*ϵρ)    # Eq. 14

    θc1 = 1/3
    θc2 = exp( 3/2*(σs*log(2))^2 ) / sqrt(2)
    θc3 = θc1/θc2

    ϵc = sqrt( -1im*ω*ϱ0*Npr*α∞ / (𝜙*σ′) )
    F̃c = (1 + θc3*ϵc + θc1*ϵc^2) / (1+ θc3*ϵc)     # Eq. 17

    C̃ω = 𝜙/(γa*P0) * ( γa - (γa-1)/(1+ϵc^-2*F̃c) )    # Eq 16
    ρ̃ω = ϱ0*α∞/𝜙 * (1 + ϵρ^-2*F̃ρ)    # Eq. 13

    Zc = 1/(ϱ0*c0) * sqrt( ρ̃ω / C̃ω)   # Eq. 19 characteristic impedance

    return Zc
end



"""

        impedanceM9(f,σ,Ω)

        impedanceM9(f,σ,Ω,σs)


Horoshenkov porous media model (σ input)

Compute characteristic ground impedance with 3 input parameters

# Arguments

- `σ`: Pa s m-2, flow resitivity (realistic values [5x10^3 3x10^7])

- `Ω`: prosity (equivalent to Ω of other models) realistics values [0.1 0.8]

- `σs`: standard deviation of pore size distribution (realistic values [0 0.5]),
default `σs` = 0.3

# Example:
```julia-repl
julia> impedanceM9(100,200_000,0.5)
julia> impedanceM9(100,200_000,0.5,0.3)
```

---
[1]. Horoshenkov, Kirill V., Alistair Hurrell, and Jean-Philippe Groby. "A three-parameter analytical model for the acoustical properties of porous media."
The Journal of the Acoustical Society of America 145.4 (2019): 2512-2517.
"""
function impedanceM9b(f,σ,Ω,σs::Any=0.3)
    𝜙 = Ω # for consistent with original notations (ref. [1])

    ω = 2π*f
    α∞ = exp( 4*(σs*log(2))^2 ) # tourtuosity See Eq. 12

    θρ1 = 1/3
    θρ2 = exp( -1/2*(σs*log(2))^2 ) / sqrt(2)
    θρ3 = θρ1/θρ2

    # convert σ to s̄ using equation 15
    s̄ = ( 8*η0*α∞ / (σ*𝜙) * exp( 6*(σs*log(2))^2 ) )^0.5

    #σ = 8*η0*α∞ / (s̄^2*𝜙) * exp( 6*(σs*log(2))^2 )    # Eq. 15
    σ′ = 8*η0*α∞ / (s̄^2*𝜙) * exp( -6*(σs*log(2))^2 )  # Eq. 18

    ϵρ = sqrt( -1im*ω*ϱ0*α∞/(𝜙*σ) )
    F̃ρ = (1 + θρ3*ϵρ + θρ1*ϵρ^2) / (1 + θρ3*ϵρ)    # Eq. 14

    θc1 = 1/3
    θc2 = exp( 3/2*(σs*log(2))^2 ) / sqrt(2)
    θc3 = θc1/θc2

    ϵc = sqrt( -1im*ω*ϱ0*Npr*α∞ / (𝜙*σ′) )
    F̃c = (1 + θc3*ϵc + θc1*ϵc^2) / (1+ θc3*ϵc)     # Eq. 17

    C̃ω = 𝜙/(γa*P0) * ( γa - (γa-1)/(1+ϵc^-2*F̃c) )    # Eq 16
    ρ̃ω = ϱ0*α∞/𝜙 * (1 + ϵρ^-2*F̃ρ)    # Eq. 13

    Zc = 1/(ϱ0*c0) * sqrt( ρ̃ω / C̃ω)   # Eq. 19 characteristic impedance

    return Zc
end
