export PlotTlr, PlotRl


"""

    PlotTlr(filename)

Plot transmission loss at particular height. This is a slice cut of full
transmission loss field using function `PlotShd()`.

# Arguments
- `filename`: *.shd

# Output
- Line graph transmission loss


# Example
```julia-repl
julia> PlotTlr("Case1.shd")
```

"""
function PlotTlr(filename::String, rdt::Real;
        xlabs::String = "Distance, m",
        ylabs::String = "Transmission loss, dB",
        ylim = (0,100),
        xlim = (0,10_000))


    pressure, Pos_r_r, Pos_r_z = read_shd(filename)

    tlt = abs.(pressure)
    tlt = -20.0f0 * log10.(tlt)

    locs = abs.(Pos_r_z[:,1] .- rdt)

    value, index = findmin(locs)

    TL_line = tlt[index,:]

    plot(Pos_r_r[:,1],TL_line,
    xlabel = xlabs,
    ylabel = ylabs,
    lw = 2.0,
    label = "TL: $rdt m")
    yflip!(true)
    ylims!(ylim)
    xlims!(xlim)

end



function PlotRl(filename,s::Vec2, r::Vec2,fcentre;
                xlabs = "Frequency, Hz",
                ylabs = "Excess attenuation, dB",
                xlim = (16,10000),
                ylim = (-40,10))

        # read range and height
        fn1 = filename[1]
        pressure, Pos_r_r, Pos_r_z = read_shd("$fn1.shd")

        locs_height = abs.(Pos_r_z[:,1] .- r.z[1])
        value, index_height = findmin(locs_height)

        locs_range = abs.(Pos_r_r[:,1] .- r.x[1])
        value, index_range = findmin(locs_range)
        #println(index_range)
        #println(index_height)

        RL_point = Matrix{Float32}(undef, length(filename), 1)

    for ii=1:length(filename)
        fn2 = filename[ii]

        pressure, Pos_r_r, Pos_r_z = read_shd("$fn2.shd")

        tlt = abs.(pressure)
        tlt = -20.0f0 * log10.(tlt)

        r2= sqrt( (s.x[1] - r.x[1])^2 + (s.z[1] - r.z[1])^2 )
        RL_point[ii] = tlt[index_height,index_range] - 20.0f0*log10.(r2) # substract sperical spreading loss

        #println(tlt[index_height,index_range])
    end # read shd

    plot(fcentre,-RL_point,xaxis=:log10,
        xlabel = xlabs,
        ylabel = ylabs,
        lw = 2.0,
        legend = false)
    #yflip!(true)
    ylims!(ylim)
    xlims!(xlim)
    #return RL_point

end
