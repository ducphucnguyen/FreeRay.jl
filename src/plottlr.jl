export PlotTlr


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
