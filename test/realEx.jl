using DelimitedFiles

elv = readdlm("./temp/elevation.txt")
ssp = readdlm("./temp/ssp.txt")

# Normalise ground level
elv[:,2] = elv[:,2] .- 1000.0
ssp[:,1] = ssp[:,1] .- 1000.0



#### Geometry
# Point source 100 Hz at 80 m above ground level
source = Source(
    frequency = 100,
    height = -80 + (-169) # 169 is ground level
)


# Multiple recievers on grid
receiver = Receiver(
    depth_point = 1001,
    range_point = 10001,
    depth = Vec2(-1000f0,0f0),
    range = Vec2(0f0,10f0)
)


# Terrain geometry
terrain = Terrain(
    interp_type = "C",
    profile = (Vec2(elv[:,1],elv[:,2]))
)


### Boundary condition
Zc = 12.81 + 11.62im
Theta, Rmag, Rphase = R_coeff(Zc;len=100)

brc = Vec3(Theta,Rmag,Rphase)
trc = Vec3([0f0,45f0,90f0],[0f0,0f0,0f0],[0f0,0f0,0f0])

reflection = Reflection_Coeff(
    top_coeff = trc,
    bottom_coeff = brc
)

### Sound speed profile

sspl = Vec2(ssp[:,1],ssp[:,2]) # case 1
ssp = SSP(sound_speed_profile= sspl)


### Analysis
opt = Analysis(
    filename = "RealCase_Bellhop_f100",
    analyse = "CG",
    option1 = "CFW",
    option2 = "F*",
    num_ray = 1601,
    alpha = Vec2(-80.0f0,80.0f0),
    box = Vec2(10f0,1000.0f0),
    step= 0
)

Environment(opt,source, receiver,ssp,terrain,reflection)

# Run Bellhop
fn= opt.filename
filename = "temp\\$fn"
run_bellhop = `bellhop $filename`
@time run(run_bellhop)


p1 = PlotRay("$filename.ray",
        xlabs = "Range, m",
        ylabs = "Height, m")

        plot!(p1,elv[:,1]*1000,elv[:,2],
        lw=0,fill = 0, color = "#8c510a",legend = false)
        yflip!(true)

        scatter!(p1,[0], [source.height],
        markersize = 6, color = "#4daf4a")

#savefig(p1,"ray_real.png")

p2 = PlotShd("$filename.shd";
        xlabs = "Range, m",
        ylabs = "Transmission loss, dB",
        cblabs = "dB",
        climb = (40,120))

        plot!(p2,elv[:,1]*1000,elv[:,2],
        lw=0,fill = 0, color = "#8c510a", legend = false)
        yflip!(true)

        scatter!(p2,[0], [source.height],
        markersize = 6, color = "#4daf4a",
        label = "Source")

#savefig(p2,"trans_real.png")
