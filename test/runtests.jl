using FreeRay
using Test, Plots


#### Geometry
# Point source 1000 Hz at 80 m
source = Source(
    frequency = 100,
    height = -5
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
    profile = (Vec2([0f0,5f0,10f0],[0f0,0f0,0f0]))
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
#sspl = Vec2([-1000f0,-500f0,0f0],[243f0,293,343]) # case 3
sspl = Vec2([-1000f0,-500f0,0f0],[343f0,343f0,343f0]) # case 1
#sspl = Vec2([-1000f0,-500f0,0f0],[443f0,393f0,343f0]) # case 2
#sspl = Vec2([-1000f0,-300f0,-100f0,0f0],[333f0,333f0,353f0,343f0]) #case 4
ssp = SSP(sound_speed_profile= sspl)

### Analysis
opt = Analysis(
    filename = "Case0_Bellhop_f10",
    analyse = "RG",
    option1 = "CFW",
    option2 = "F*",
    num_ray = 161,
    alpha = Vec2(-80.0f0,80.0f0),
    box = Vec2(10f0,1000.0f0),
    step= 0
)

Environment(opt,source, receiver,ssp,terrain,reflection)


# Run Bellhop
fn= opt.filename
filename = "$fn"
run_bellhop = `bellhop $filename`
@time run(run_bellhop)

p1 = PlotRay("$filename.ray",
        xlabs = "Range, m",
        ylabs = "Height, m")

#savefig(p1,"ray1.png")

#p2 = PlotShd("$filename.shd";
#        xlabs = "Range, m",
#        ylabs = "Transmission loss, dB",
#        cblabs = "dB",
#        climb = (40,80))

#savefig(p2,"transc4.png")

#PlotTlr("$filename.shd", -7;
#        xlabs = "Range, m",
#        ylabs = "Transmission loss, dB",
#        xlim = (0,10000),
#        ylim = (20,120))


rmfile(filename)

@testset "FreeRay.jl" begin
    # Write your tests here.
end


#read_shd("Case0_Bellhop_f10.shd")
