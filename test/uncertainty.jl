## Load Packages
using FreeRay, DataFrames, CSV
using Base.Threads


## Impedance input
# create an empty dataframe
df1 = DataFrame( freq = Float64[],   # 1/3-octave freq.
                sigma = Float64[],  # flow resistivity
                impedMl = Int32[],
                Zc = Complex{Float64}[])

#Zc = Complex{Float64}
# 1/3-octave, freq 15 >2000 Hz
CenterFreq = getCenterFreq(bandwidth=3,lim=(15,2000))

# Impedance models
sigma = [10,200,2000]*1000 # Pa s/m2 (See Table 5.1 Bies and Hansen)


for i_1=1:length(CenterFreq)
        for i_2=1:length(sigma)

                f = CenterFreq[i_1]; σ = sigma[i_2]; Ω = 0.5 # porosity
                local Zc = [  impedanceM1(f,σ),     # tested!
                        impedanceM2(f,σ),     # tested!
                        impedanceM3(f,σ,Ω),    # tested!
                        impedanceM4(f,σ,Ω),    # tested!
                        impedanceM5(f,σ,Ω),    # tested!
                        impedanceM6(f,σ,Ω),    # tested!
                        impedanceM7(f,σ,Ω),    # tested!
                        impedanceM8(f,σ,Ω),    # tested!
                        impedanceM9b(f,σ,Ω)     ]

                for i in 1:9
                        push!(df1, (f, σ, i,Zc[i]))
                end

        end # end i_2
end # end i_1

## Wind input
df2 = DataFrame( alpha = Float64[],   # 1/3-octave freq.
                z0 = Float64[],  # flow resistivity
                windMl = Int32[])


# wind models
alpha = [0.13, 0.21, 0.39]
zz0 = [0.002, 0.03, 0.26]

vref = 2.7; href = 10 # wind speed and ref wind
h = range(0,1000,step = 1.0) # height step

rows = length(h); cols = length(alpha)*8
vh = Array{Float64,2}(undef, rows, cols)


for i_1 = 1:length(alpha)

    α = alpha[i_1]; z0 = zz0[i_1]
    k = (i_1-1)*8 + 1

    # log Linear - law model
    for i=2:length(h)
        vh[i,k] = windprofile_logLL(h[i],z0,vref,href)
    end

    # logarithmic law model
    vh2 = similar(h) # pre-allocation
    for i=2:length(h)
        vh[i,k+1]  = windprofile_logL(h[i],z0,vref,href)
    end

    # DH log model
    vh3 = similar(h) # pre-allocation
    for i=2:length(h)
        vh[i,k+2] = windprofile_DH(h[i],z0,vref,href)
    end


    # power law model
    vh4 = similar(h) # pre-allocation
    for i=2:length(h)
        vh[i,k+3] = windprofile_PL_α(h[i],1/7,vref,href)
    end


    # power law model mean anual
    vh5 = similar(h) # pre-allocation
    for i=2:length(h)
        vh[i,k+4] = windprofile_PL_α(h[i],α,vref,href)
    end


    # power law model Counihan model
    vh6 = similar(h) # pre-allocation
    αC = 0.24 + 0.096*log(z0) + 0.016*(log(z0))^2
    for i=2:length(h)
        vh[i,k+5] = windprofile_PL_α(h[i],αC,vref,href)
    end


    # power law SH model
    vh7 = similar(h) # pre-allocation
    αSH = 1.03 + 0.31*log(z0) + 0.03*(log(z0))^2
    for i=2:length(h)
        vh[i,k+6] = windprofile_PL_α(h[i],αSH,vref,href)
    end


    # power law αP model
    vh8 = similar(h) # pre-allocation
    for i=2:length(h)
        vh[i,k+7] = windprofile_PL_α_P(h[i],z0,vref,href)
    end

    for i in 1:8
        push!(df2, (α, z0, i))
    end

end # end i_1
vh[1,:] .= 0.0
df2.idxWindprofile = 1:24

## Combine dataframe for easily control

df = crossjoin(df1, df2, makeunique = true)
TLoss = Array{Float32,2}(undef, nrow(df), 20)

## Bellhop input setup


function inforEx(df,simID) # extract information in dataframe
    freqSim = df.freq[simID]
    ZcSim = df.Zc[simID]
    idxWind = df.idxWindprofile[simID]
    return freqSim, ZcSim, idxWind
end



# Multiple recievers on grid
receiver = Receiver(
    depth_point = 1,
    range_point = 20,
    depth = Vec2(-1.5f0,-1.5f0),
    range = Vec2(0.5f0,10f0)
)


# Terrain geometry
terrain = Terrain(
    interp_type = "L",
    profile = (Vec2([0f0,5f0,10f0],[0f0,0f0,0f0]))
)



@time @threads for simID = 1:1#nrow(df)
    println(simID)

    freqSim, ZcSim, idxWind = inforEx(df,simID)

    # Point source at 80 m
    source = Source(
        frequency = Float32.(freqSim), # frequency dependence
        height = -80f0
    )


    ### Boundary condition
    Theta, Rmag, Rphase = R_coeff(ZcSim;len=100) # Zc dependence
    brc = Vec3(Theta,Rmag,Rphase)
    trc = Vec3([0f0,45f0,90f0],[0f0,0f0,0f0],[0f0,0f0,0f0])
    reflection = Reflection_Coeff(
        top_coeff = trc,
        bottom_coeff = brc
    )


    # Sound speed profile
    hneg = -h[end:-1:1]
    soundspeed = 343 .+ vh[:,idxWind][end:-1:1]
    sspl = Vec2(Float32.(hneg),Float32.(soundspeed)) # sound speed profile
    ssp = SSP(sound_speed_profile = sspl)


    ### Analysis
    opt = Analysis(
        filename = "Uncertainty_case1_$simID",
        analyse = "CB",
        option1 = "CFW",
        option2 = "F*",
        num_ray = 16001,
        alpha = Vec2(-80.0f0,80.0f0),
        box = Vec2(10f0,1000.0f0),
        step= 0.1
    )

    # Create environment files
    Environment(opt,source, receiver,ssp,terrain,reflection)


    # Run Bellhop
    fn= opt.filename
    filename = "temp\\$fn"
    run_bellhop = `bellhop $filename`
    run(run_bellhop)
    rmfile(filename)

    #p1 = PlotRay("$filename.ray",
    #        xlabs = "Range, m",
    #        ylabs = "Height, m")

    #p2 = PlotShd("$filename.shd";
    #        xlabs = "Range, m",
    #        ylabs = "Transmission loss, dB",
    #        cblabs = "dB",
    #        climb = (40,80))

    #PlotTlr("$filename.shd", -1.5;
    #        xlabs = "Range, m",
    #        ylabs = "Transmission loss, dB",
    #        xlim = (0,10000),
    #        ylim = (20,120))

    pressure, Pos_r_r, Pos_r_z = read_shd("$filename.shd")
    tlt = -20.0f0 * log10.(abs.(pressure))

    TLoss[simID,:] = tlt

end # end loop simID


CSV.write("df.csv", df)
CSV.write("TLoss.csv",  DataFrame(TLoss), writeheader=false)
