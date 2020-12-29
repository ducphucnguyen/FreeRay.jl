
using Plots
filename = "Case0_Bellhop_f10.shd"
recl = Array{Int32}(undef, 1, 1)


 #read!(filename, recl)

io = open(filename,"r")

#open(filename) do file
recl = read(io, Int32)

for i=1:80
        println(read(io, Char))
end

#end


seekstart(io)
seek(io, 4*recl)

for i=1:10
        println(read(io, Char))
end

seekstart(io)
seek(io, 2*4*recl) # end of 2nd record

Nfreq = read(io, Int32)
Ntheta = read(io, Int32)

Nsx = read(io, Int32)
Nsy = read(io, Int32)
Nsz = read(io, Int32)

Nrz = read(io, Int32)
Nrr = read(io, Int32)
freq0 = read(io, Float32)
atten = read(io, Float32)

seekstart(io)
seek(io, 3*4*recl) # end of 3rd record

freqVec = read(io, Float64)

seekstart(io)
seek(io, 4*4*recl) # end of 4th record

Pos_theta = read(io, Float64)

seekstart(io)
seek(io, 5*4*recl) # end of 5th record

Pos_s_x = read(io, Float32)

seekstart(io)
seek(io, 6*4*recl) # end of 6th record

Pos_s_y = read(io, Float32)


seekstart(io)
seek(io, 7*4*recl) # end of 7th record

Pos_s_z = read(io, Float32)

seekstart(io)
seek(io, 8*4*recl) # end of 8th record

Pos_r_z = Array{Float32}(undef, Nrz, 1)
read!(io, Pos_r_z)


seekstart(io)
seek(io, 9*4*recl) # end of 9th record

Pos_r_r = Array{Float32}(undef, Nrr, 1)
read!(io, Pos_r_r)


pressure = Array{Complex{Float32}}(undef,Nrz,Nrr)
count = 10

function read_pressure!(pressure,count)
        for ii = 1:Nrz
                seekstart(io)
                seek(io, count*4*recl) # end of 10th record

                temp = Array{Float32}(undef, 2*Nrr, 1)
                read!(io, temp)

                temp = temp .+ 1f-6

                real_temp = temp[1:2:2*Nrr]
                im_temp = temp[2:2:2*Nrr]
                complex_temp = real_temp .+ 1im*im_temp

                pressure[ii,:] = complex_temp
                count +=1
        end
end

read_pressure!(pressure,count)
position(io)
close(io) # Done read shd file

tlt = abs.(pressure)
tlt = -20.0f0 * log10.(tlt)

#seekend(io)

heatmap(Pos_r_r[:,1],Pos_r_z[:,1],  tlt,
        clim=(40,80),
        c=cgrad(:Paired_6,rev = true),
        xlabel="Distance, m", ylabel="Transmission loss, dB")
