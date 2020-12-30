export Environment

# dependent package
#using DelimitedFiles

function Environment(option::Options,
                    source::Geometry,
                    receiver::Geometry,
                    ssp::Atmosphere,
                    terrain::Geometry,
                    reflection::Boundary)

    fn = option.filename
    filename = "temp\\$fn.env" # environment file

    freq = source.frequency
    nmedia = 1
    opt1 = option.option1
    opt2 = option.option2
    botdepth = maximum(ssp.sound_speed_profile.x)

    open(filename,"w") do io
        write(io,"'$fn'         ! title\n")
        write(io,"$freq         ! frequency (Hz)\n")
        write(io,"$nmedia       ! nmedia\n")
        write(io,"'$opt1'       ! C-linear, F-file\n") # option 1
        write(io,"51 0.0 $botdepth ! depth of bottom\n")

        ###### Sound speed profile
        for i=1:size(ssp.sound_speed_profile.x,1)
            zi = ssp.sound_speed_profile.x[i]
            vi = ssp.sound_speed_profile.z[i]
            #println(zi)
            write(io,"$zi $vi /\n")
        end
        ###### End read sound speed

        write(io,"'$opt2' 0.0 \n") # option 2


        ##---> Source information
        nsources = 1
        write(io,"$nsources ! number of sources \n")
        source_height = source.height[1]
        write(io,"$source_height / ! SD (1:NSD), m\n")


        ##----> Receiver information
        nrd = receiver.depth_point
        rd = receiver.depth
        nr = receiver.range_point
        r = receiver.range

        write(io,"$nrd      ! number of receivers in depth \n")
        if nrd==1
            rd1 = rd.x[1]
            write(io,"$rd1 / ! RD(1:RD) \n")
        else
            rdx = rd.x[1]
            rdz = rd.z[1]
            write(io,"$rdx $rdz / ! RD(1:RD) \n")
        end
        write(io,"$nr       ! number of receivers in range \n")
        rx = r.x[1]
        rz = r.z[1]
        write(io,"$rx $rz /  ! R(1:NR) \n")



        ## option 3
        opt3 = option.analyse
        nbeam = option.num_ray

        write(io,"'$opt3'   ! R/C/I/S\n") # option3
        write(io,"$nbeam    ! number of ray \n")
        neg_alpha = option.alpha.x[1]
        pos_alpha = option.alpha.z[1]
        write(io,"$neg_alpha $pos_alpha / ! alpha, deg \n")


        zmax = option.box.z[1] + 0.1*(option.box.z[1])
        rmax = option.box.x[1] + 0.1*(option.box.x[1])
        raystep = option.step
        write(io,"$raystep $zmax $rmax ! step (m), zbox(m), rbox(km) \n")

    end # end write environment file


    ### Write battery files
    filename2 = "temp\\$fn.bty" # battery file
    interp_tp = terrain.interp_type
    numpoint = size(terrain.profile.x,1)

    open(filename2,"w") do io
        write(io,"'$interp_tp' \n")
        write(io,"$numpoint   \n")
        for i=1:numpoint
            zi = terrain.profile.x[i]
            vi = terrain.profile.z[i]
            #println(zi)
            write(io,"$zi $vi \n")
        end
    end # end write battery file



    ### Write top and bottom reflection coefficient files
    filename3 = "temp\\$fn.brc" # bottom reflection
    num_bot = size(reflection.bottom_coeff.x,1)
    open(filename3,"w") do io
        write(io,"$num_bot   \n")
        for i=1:num_bot
            xi = reflection.bottom_coeff.x[i]
            yi = reflection.bottom_coeff.y[i]
            zi = reflection.bottom_coeff.z[i]
            #println(zi)
            write(io,"$xi $yi $zi \n")
        end
    end # end write bottom reflection coefficient file


    filename4 = "temp\\$fn.trc" # top reflection
    num_top = size(reflection.top_coeff.x,1)
    open(filename4,"w") do io
        write(io,"$num_top   \n")
        for i=1:num_top
            xi = reflection.top_coeff.x[i]
            yi = reflection.top_coeff.y[i]
            zi = reflection.top_coeff.z[i]
            #println(zi)
            write(io,"$xi $yi $zi \n")
        end
    end # end write top reflection coefficient file



end
