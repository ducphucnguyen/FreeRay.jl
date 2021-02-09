export PlotShd

"""

    PlotShd(filename)

Plot transmission loss field

# Arguments
- `filename`: *.shd

# Output
- Heatmap transmission loss


# Example
```julia-repl
julia> PlotShd("Case1.shd")
```

"""
function PlotShd(filename::String;
        xlabs::String = "Distance, m",
        ylabs::String = "Transmission loss, dB",
        cblabs::String = "TL, dB",
        climb = (40,80))

        pressure, Pos_r_r, Pos_r_z = read_shd(filename)

        tlt = abs.(pressure)
        tlt = -20.0f0 * log10.(tlt)

        #seekend(io)

        heatmap(Pos_r_r[:,1],Pos_r_z[:,1],  tlt,
                clim= climb,
                c=cgrad(:Paired_6,rev = true),
                colorbartitle = cblabs,
                xlabel=xlabs, ylabel=ylabs)
        yflip!(true)

end # PlotShd function
