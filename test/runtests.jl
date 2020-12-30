using FreeRay
using Test


#### Geometry
# Point source 1000 Hz at 80 m
source = Source(
    frequency = 10,
    height = -80
)

# Multiple recievers on grid
receiver = Receiver(
    depth_point = 201,
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
brc = Vec3([0f0,45f0,90f0],[1f0,1f0,1f0],[0f0,0f0,0f0])
trc = Vec3([0f0,45f0,90f0],[0f0,0f0,0f0],[0f0,0f0,0f0])

reflection = Reflection_Coeff(
    top_coeff = trc,
    bottom_coeff = brc
)


### Sound speed profile
sspl = Vec2([-1000f0,-500f0,0f0],[343f0,333f0,323f0])
ssp = SSP(sound_speed_profile= sspl)

ssp.sound_speed_profile.x
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
filename = "temp\\$fn"
run_bellhop = `bellhop $filename`
@time run(run_bellhop)

PlotRay("$filename.ray",
        xlabs = "Range, m",
        ylabs = "Height, m")

p = PlotShd("$filename.shd";
        xlabs = "Range, m",
        ylabs = "Transmission loss, dB",
        cblabs = "dB",
        climb = (40,80))
savefig(p,"plot.png")

PlotTlr("$filename.shd", -50;
        xlabs = "Range, m",
        ylabs = "Transmission loss, dB",
        xlim = (0,10000),
        ylim = (20,120))


rmfile(filename)

@testset "FreeRay.jl" begin
    # Write your tests here.
end


#read_shd("Case0_Bellhop_f10.shd")
