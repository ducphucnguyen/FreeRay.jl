include("src/ssp/windprofile.jl")
using .windprofile
using Plots
#using BenchmarkTools

z0 = 0.03; α = 0.21; vref = 2.7; href = 10
h = range(0,1000,step = 1.0)

# log Linear - law model
vh1 = similar(h) # pre-allocation
for i=2:length(h)
    vh1[i] = windprofile_logLL(h[i],z0,vref,href)
end
plot(vh1,h)

# logarithmic law model
vh2 = similar(h) # pre-allocation
for i=2:length(h)
    vh2[i] = windprofile_logL(h[i],z0,vref,href)
end
plot!(vh2,h)

# DH log model
vh3 = similar(h) # pre-allocation
for i=2:length(h)
    vh3[i] = windprofile_DH(h[i],z0,vref,href)
end
plot!(vh3,h)

# power law model
vh4 = similar(h) # pre-allocation
for i=2:length(h)
    vh4[i] = windprofile_PL_α(h[i],1/7,vref,href)
end
plot!(vh4,h)

# power law model mean anual
vh5 = similar(h) # pre-allocation
for i=2:length(h)
    vh5[i] = windprofile_PL_α(h[i],α,vref,href)
end
plot!(vh5,h)

# power law model Counihan model
vh6 = similar(h) # pre-allocation
αC = 0.24 + 0.096*log(z0) + 0.016*(log(z0))^2
for i=2:length(h)
    vh6[i] = windprofile_PL_α(h[i],αC,vref,href)
end
plot!(vh6,h)

# power law SH model
vh7 = similar(h) # pre-allocation
αSH = 1.03 + 0.31*log(z0) + 0.03*(log(z0))^2
for i=2:length(h)
    vh7[i] = windprofile_PL_α(h[i],αSH,vref,href)
end
plot!(vh7,h)


# power law αP model
vh8 = similar(h) # pre-allocation
for i=2:length(h)
    vh8[i] = windprofile_PL_α_P(h[i],z0,vref,href)
end
plot!(vh8,h)
