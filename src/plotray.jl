export PlotRay

#rayfil = "Case0_Bellhop_f10.ray"

function PlotRay(rayfil;
    xlabs = "Range, m",
    ylabs = "Height, m")

    # parse functions
    function parse_numbers(s)
        pieces = split(s, ' ', keepempty=false)
        map(pieces) do piece
            parse(Float64, piece)
        end
    end


    function parse_int(s)
        pieces = split(s, ' ', keepempty=false)
        map(pieces) do piece
            parse(Int, piece)
        end
    end

    io = open(rayfil,"r")
    lines = readlines(io)
    close(io)


    TITLE   =   lines[1]
    FREQ    =   parse_numbers(lines[2])[1]
    Nsxyz   =   parse_numbers(lines[3])
    NBeamAngles = parse_int(lines[4])

    DEPTHT = parse_numbers(lines[5])
    DEPTHB = parse_numbers(lines[6])

    Type1        = lines[7]

    Nsx    = Nsxyz[1]
    Nsy    = Nsxyz[2]
    Nsz    = Nsxyz[3]

    Nalpha = NBeamAngles[1]
    Nbeta  = NBeamAngles[2]

    # Extract title
    m = match(r"BELLHOP- .*? ", TITLE)
    TITLE = m.match

    #cmp(Type1, " 'rz'") == 0



    ### Extract ray data
    df = DataFrame(Nalpha = Float64[],
                    TopBnc = Int[],
                    BotBnc = Int[],
                    r = Float64[],
                    z = Float64[])



    st = 8
    function ray_extract!(df,lines,st)
        for ibeam = 1:Nalpha
            alpha0 = parse_numbers(lines[st])
            nsteps = parse_int(lines[st+1])[1]

            NumTopBnc = parse_int(lines[st+1])[2]
            NumBotBnc = parse_int(lines[st+1])[3]

            for i = st+2 : st+2+nsteps-1
                ray = parse_numbers(lines[i])
                push!(df, (alpha0[1], NumTopBnc[1],NumBotBnc[1], ray[1],ray[2]))
            end

            st += 2 + nsteps
        end
    end

    ray_extract!(df,lines,st)

    #df.z = 1000 .- df.z
    # group data
    gdf = groupby(df, :Nalpha)


    # Plot ray
    #gr()
    p = plot()
    xlabel!(xlabs)
    ylabel!(ylabs)
    #xlims!(0,10_000)
    #ylims!(0,1000)
    yflip!(true)


    for i=1:length(gdf)
        if (gdf[i].TopBnc[1] == 1) & (gdf[i].BotBnc[1] == 1) # hit both boundaries
            plot!(p,gdf[i].r,gdf[i].z,
                legend = false,
                color = "#e41a1c",
                α = 0.5)
        elseif (gdf[i].BotBnc[1] == 1) # hit bottom
            plot!(p,gdf[i].r,gdf[i].z,
                legend = false,
                color = "#377eb8",
                α = 0.5)

        elseif (gdf[i].TopBnc[1] == 1)  # hit top
            plot!(p,gdf[i].r,gdf[i].z,
                legend = false,
                color = "#4daf4a",
                α = 0.5)
        else
            plot!(p,gdf[i].r,gdf[i].z,
                legend = false,
                color = "#984ea3",
                α = 0.5)
        end

    end
    current()

    #return df

end



#savefig(p,"plot.pdf")
