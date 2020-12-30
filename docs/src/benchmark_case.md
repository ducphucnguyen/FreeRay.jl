# Benchmark cases

In this example, we will use FreeRay to model 4 benchmark cases for outdoor sound propagation as published by Attenborough et al. (1995).


There is an unit point source at ``h_s = 5.0`` m, a receiver at ``h_r = 1.0`` m and at a horizontal range ``R=10,000`` m. The source emits a constant tone of ``f = 100`` Hz.

The ground surface is treated as an impedance boundary with the specific characteristic impedance ``Z_c = 12.81 + i11.62``. This value is used to calculate spherical-wave reflection coefficients.

The differences between 4 benchmark cases are the use of different sound speed profiles such as constant, positive, negative and composite profiles.

Ref: `Attenborough, Keith, et al. "Benchmark cases for outdoor sound propagation models." The Journal of the Acoustical Society of America 97.1 (1995): 173-191.`


## Case 1: Constant sound speed profile

Load FreeRay package

```julia
using FreeRay
```

### Source

We may notice that the source height is inputted as a negative number. This is convention of Bellhop where upper and lower spaces are modelled as negative and positive axis, respectively. We are interested in upper space, so hereafter all input values for height are negative numbers.

```julia
source = Source(
        frequency = 100f0, # Hz, f0 indicate Float32 number.
        height = -5f0) # m, height
```

### Receiver

In the benchmark case, only receiver at 1.0 m is interested, but to plot the transmission loss field, we here will calculate for every grid points spacing 1.0 m in both vertical and horizontal directions. The investigation region is 1,000 m in height and 10,000 m in range. Obviously, this will cover the configuration of the benchmark case!

```julia
receiver = Receiver(
        depth_point = 1001, # number of points in height
        range_point = 10001, # number of points in range
        depth = Vec2(-1000f0,0f0), # height between -1000 m and 0
        range = Vec2(0f0,10f0)) # range between 0 and 10 km (range is always in km)
```


### Terrain geometry

We assume that the ground elevation is flat for now, real ground elevation will be discussed in other examples.

```julia
terrain = Terrain(
    interp_type = "C", # interpolation method for ground elevation
    profile = (Vec2([0f0,5f0,10f0],[0f0,0f0,0f0])) # need 3 points for modelling flat terrain
)
```


### Boundary condition

The ground surface is modelled using reflection coefficients which are calculated from characteristic ground impedance ``Z_c``. We may not show calculation details in here, but this can be calculated using `Q_reflection` function. The top boundary is atmospheric, thus can be modelled as "no reflection". In other words, the reflection coefficients are zero.

```julia

# Vec3(grazing angle, coefficient, phase angle)
brc = Vec3([0f0,45f0,90f0],[1f0,1f0,1f0],[0f0,0f0,0f0])
trc = Vec3([0f0,45f0,90f0],[0f0,0f0,0f0],[0f0,0f0,0f0])

reflection = Reflection_Coeff(
    top_coeff = trc,
    bottom_coeff = brc)
```


### Sound speed profile

In this case, we have sound speed is constant ``c_0 = 343`` m/s.

```julia
# Vec2 (height, sound speed)
sspl = Vec2([-1000f0,-500f0,0f0],[343f0,343f0,343f0])
ssp = SSP(sound_speed_profile = sspl)
```

### Analysis

This is an important part to specify what analysis we want to run. To just analyse ray tracing, the option is `analyse = "R"`. To analyse acoustic fields, we need to use following options:

* `analyse = "CG"` - coherent geometric ray model
* `analyse = "IG"` - incoherent geometric ray model
* `analyse = "CB"` - coherent Gaussian ray model
* `analyse = "IB"` - incoherent Gaussian ray model

```julia
opt = Analysis(
    filename = "Case0_Bellhop_f10", # name of output files
    analyse = "RG", # analysis options C-coherent, I-incoherent, G-Geometric ray, B- Gaussian ray.
    option1 = "CFW",
    option2 = "F*",
    num_ray = 161, # number of ray, resulting in resolution of take-off angles
    alpha = Vec2(-80.0f0,80.0f0), # take-off angle from -80 to 80
    box = Vec2(10f0,1000.0f0),
    step= 0
)
```

### Create input files

```julia
Environment(opt,source, receiver,ssp,terrain,reflection)
```


### Run Bellhop

```julia
fn= opt.filename
filename = "temp\\$fn"
run_bellhop = `bellhop $filename`
@time run(run_bellhop)
```

### Plots

```julia
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
```


## Case 2

## Case 3

## Case 4
