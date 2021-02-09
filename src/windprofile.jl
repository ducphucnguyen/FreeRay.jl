export windprofile_logLL, windprofile_logL, windprofile_DH,
      windprofile_PL_α, windprofile_PL_α_P, windprofile_PL_n_JM,
      windprofile_PL_n_SR





include("constant.jl")
#using .constant

# Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
# Renewable and Sustainable Energy Reviews 102 (2019): 215-233.


# Monin-obukhov length
"""

    Monin_Obukhov_length(u✶,H)

    Monin_Obukhov_length(u✶,H,T)

calculate the Monin-Obukhov length

# Arguments

- `u✶`: m.s-1, friction velocity. `u✶` for light, moderate and strong wind conditions
can be selected as 0.1, 0.3 and 0.6 m/s respectively

- `H`: W.m-2, sensible heat flux. For mostly sunny conditions during the daytime,
`H` may be set 200 W.m-2; for cloudy conditions, day or night, `H` ~ 0 W.m-2;
for clear skies at night `H` ~ -4 W.m-2 for light wind conditions, and
  `H` ~ -20 W.m-2 for moderate or strong wind.

- `T`: ᵒC, air temperature, default `T` = 20 ᵒC

# Example:
```julia-repl
julia> Monin_Obukhov_length(0.3,-20)
```
# Reference
[1]. Foken, T, 2008: Micrometeorology. Springer, Berlin, Germany.
"""
function Monin_Obukhov_length(u✶,H,T=20)
  T += Kelvin

  L = (-ϱ0*cP*T*u✶^3) / (κ*g0*H)

  return L
end


# correction under non-neutral conditions
"""

  𝛹m(z/L)

correct deviations from the wind profile under non-neutral conditions

# Argument

- `z/L`: where `L` is the Monin-Obukhov length
"""
function 𝛹m(x)
      if x>0 # stable conditions
        return -5*x
      else # unstable conditions
        x2 = ( 1 - 15*(x) )^(1/4)
        value = 2*log( (1+x2)/2 ) + log( (1+x2^2)/2 ) - 2*atan(x2) + π/2
        return value
    end
end


"""

    𝛷m(z/L)

correct deviations from the wind profile under non-neutral conditions

# Argument

- `zg/L`: where `L` is the Monin-Obukhov length

"""
function 𝛷m(x)
  if x>0
    return 1+5*x
  else
    return (1 - 15*x)^(-1/4)
  end
end

"""

  Coriolis(lat)

calculate Coriolis frequency, f

# Arguments

- `lat`: deg, latitude

# Example
```julia-repl
julia> Coriolis(45)
```
"""
function Coriolis(lat)
  ω = 7292115*10^-11 # rad/s, rotation rate of the Earth
  f = 2*ω*sin(lat*π/180) # Coriolis parameter
  return f
end


"""

    windprofile_logLL(h,z0,vref,href)

    windprofile_logLL(h,z0,vref,href, u✶, H)


calculate wind speed at a given height using Log-linear law

# Arguments

- `h`: m, height need to extrapolate wind speed

- `z0`: m, roughness length

- `vref`: m/s, wind speed at reference height

- `href`: m, reference height

- `u✶`: m.s-1, friction velocity, default `u✶` = 0.3 for moderate wind condition

- `H`: W.m-2, sensible heat flux, default `H` = -20 for clear sky at night with
moderate wind condition

# Example
```julia-repl
julia> windprofile_logLL(10,0.05,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.

"""
function windprofile_logLL(h,z0,vref,href, u✶=0.3, H=-20)

    L = Monin_Obukhov_length(u✶,H)

    vh = vref*( log(h/z0) - 𝛹m(h/L) ) / ( log(href/z0) - 𝛹m(href/L) )

    return vh

end



"""

    windprofile_logL(h,z0,vref,href)


calculate wind speed at a given height using Log-linear law (neutral conditions)

# Arguments

- `h`: m, height need to extrapolate wind speed

- `z0`: m, roughness length

- `vref`: m/s, wind speed at reference height

- `href`: m, reference height

# Example
```julia-repl
julia> windprofile_logL(10,0.05,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.

"""
function windprofile_logL(h,z0,vref,href)
  vh = vref* log(h/z0) / log(href/z0)
  return vh
end



# Eaves and Harris model
"""

    windprofile_DH(h,z0,vref,href)

    windprofile_DH(h,z0,vref,href,u✶,lat)


calculate wind speed at a given height using Deaves and Harris model
(near neutral strong wind conditions)

# Arguments

- `h`: m, height need to extrapolate wind speed

- `z0`: m, roughness length

- `vref`: m/s, wind speed at reference height

- `href`: m, reference height

- `u✶`: m.s-1, friction velocity, default `u✶` = 0.3 for moderate wind condition

- `lat`: deg, latitude in degree, default `lat` = 30 for South Australia

# Example
```julia-repl
julia> windprofile_DH(10,0.05,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.
"""
function windprofile_DH(h,z0,vref,href, u✶=0.3,lat=30)

  f = Coriolis(lat)   # Coriolis parameter
  B =  6.0            # empirical constant

  hf = u✶/(B*f) # neutral ABL height

  vh = vref* ( log(h/z0) + 5.75*(h/hf) - 1.88*(h/hf)^2 - 1.33*(h/hf)^3 + 0.25*(h/hf)^4 ) /
     ( log(href/z0) + 5.75*(href/hf) - 1.88*(href/hf)^2 - 1.33*(href/hf)^3 + 0.25*(href/hf)^4 )

  return vh

end



# Power law
"""

    windprofile_PL_α(h,α,vref,href)


calculate wind speed at a given height using power law model

# Arguments

- `h`: m, height need to extrapolate wind speed

- `α`: dimensionless exponent

- `vref`: m/s, wind speed at reference height

- `href`: m, reference height

# Example
```julia-repl
julia> windprofile_PL_α(10,1/7,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.

"""
function windprofile_PL_α(h,α,vref,href)
  vh = vref*(h/href)^(α)

  return vh
end




"""


    windprofile_PL_α_P(h,α,vref,href)

    windprofile_PL_α_P(h,z0,vref,href, u✶ H)


calculate wind speed at a given height using MOST

# Arguments

- `h`: m, height need to extrapolate wind speed

- `α`: dimensionless exponent

- `vref`: m/s, wind speed at reference height

- `href`: m, reference height

# Example
```julia-repl
julia> windprofile_PL_α_P(10,1/7,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.
"""
function windprofile_PL_α_P(h,z0,vref,href, u✶=0.3, H=-20)
  zg = (h*href)^0.5

  L = Monin_Obukhov_length(u✶,H)

  α = 𝛷m(zg/L) / ( log(zg/z0) - 𝛹m(zg/L) )

  vh = vref*(h/href)^α

  return vh

end


"""


    windprofile_PL_n_JM(z2,z1,c1,k1)

    windprofile_PL_n_JM(z2,z1,c1,k1)


calculate wind speed at a given height using Weibull probability function

# Arguments

- `z2`: m, height need to extrapolate wind speed

- `z1`: height at available data

- `c1`: Weibull parameter

- `k1`: Weibull parameter

# Example
```julia-repl
julia> windprofile_PL_α_P(10,1/7,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.

"""
function windprofile_PL_n_JM(z2,z1,c1,k1)

  zr = 10 # reference height
  k2 = k1*( 1 - 0.0881*log(z1/zr) ) / ( 1 - 0.0881*log(z2/zr) )

  n = (0.37 - 0.0881*log(c1)) / ( 1 - 0.0881*log(z1/zr) )

  c2 = c1*(z2/z1)^n

  return c2, k2

end




"""


    windprofile_PL_n_SR(z2,z1,c1,k1)

    windprofile_PL_n_SR(z2,z1,c1,k1)


calculate wind speed at a given height using Weibull probability function

# Arguments

- `z2`: m, height need to extrapolate wind speed

- `z1`: height at available data

- `c1`: Weibull parameter

- `k1`: Weibull parameter

# Example
```julia-repl
julia> windprofile_PL_N_SR(10,1/7,3,1.5)
```

# Reference
[1]. Gualtieri, Giovanni. "A comprehensive review on wind resource extrapolation models applied in wind energy."
Renewable and Sustainable Energy Reviews 102 (2019): 215-233.

"""
function windprofile_PL_n_SR(z2,z1,c1,k1,z0)

  zr = 10 # reference height
  vh = 67 # m/s
  α0 = (z0/zr)^0.2

  k2 = k1*( 1 - 0.0881*log(z1/zr) ) / ( 1 - 0.0881*log(z2/zr) )

  n = α0*( 1 - log(c1)/log(vh) ) / ( 1 - α0*log(z1/zr)/log(vh) )

  c2 = c1*(z2/z1)^n

  return c2, k2

end
