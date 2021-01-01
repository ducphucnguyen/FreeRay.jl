export Vec2, Vec3, rmfile, read_shd

"""
    Vec2
This is the central type for BellHop2D. All of the other types are defined building
upon this.
All the fields of the Ve2 instance contains `Array`s.
### Fields:
* `x`
* `z`
The types of `x` and `z` must match. Also, if scalar input is given to the
constructor it will be cnverted into a 1-element Vector.
"""
struct Vec2{T<:AbstractArray}
    x::T
    z::T
    function Vec2(x::T, z::T) where {T<:AbstractArray}
        @assert size(x) == size(z)
        new{T}(x, z)
    end
end

Vec2(a::T) where {T<:Real} = Vec3([a], [a])

Vec2(a::T) where {T<:AbstractArray} = Vec2(copy(a), copy(a))

Vec2(a::T, b::T) where {T<:Real} = Vec2([a], [b])

#Vec2(1.01f0,2.0f0)

# -------- #
# Vector 3 #
# -------- #

"""
    Vec3
This is the central type for Bellhop3D. All of the other types are defined building
upon this.
All the fields of the Vec3 instance contains `Array`s. This ensures that we can collect
the gradients w.r.t the fields using the `Params` API of Zygote.
### Fields:
* `x`
* `y`
* `z`
The types of `x`, `y`, and `z` must match. Also, if scalar input is given to the
constructor it will be cnverted into a 1-element Vector.
"""
struct Vec3{T<:AbstractArray}
    x::T
    y::T
    z::T
    function Vec3(x::T, y::T, z::T) where {T<:AbstractArray}
        @assert size(x) == size(y) == size(z)
        new{T}(x, y, z)
    end
    function Vec3(x::T1, y::T2, z::T3) where {T1<:AbstractArray, T2<:AbstractArray, T3<:AbstractArray}
        # Yes, I know it is a terrible hack but Zygote.FillArray was pissing me off.
        T = eltype(x) <: Real ? eltype(x) : eltype(y) <: Real ? eltype(y) : eltype(z)
        @warn "Converting the type to $(T) by default" maxlog=1
        @assert size(x) == size(y) == size(z)
        new{AbstractArray{T, ndims(x)}}(T.(x), T.(y), T.(z))
    end
end

Vec3(a::T) where {T<:Real} = Vec3([a], [a], [a])

Vec3(a::T) where {T<:AbstractArray} = Vec3(copy(a), copy(a), copy(a))

Vec3(a::T, b::T, c::T) where {T<:Real} = Vec3([a], [b], [c])


# -------- #
# rmfile #
# -------- #
function rmfile(filename::String)
    f1 = "$filename.brc"
    f2 = "$filename.bty"
    f3 = "$filename.env"
    f4 = "$filename.trc"
    f5 = "$filename.prt"

    rm(f1, force=true)
    rm(f2, force=true)
    rm(f3, force=true)
    rm(f4, force=true)
    rm(f5, force=true)

end


# -------- #
# read_shd file #
# -------- #
function read_shd(filename::String)
    recl = Array{Int32}(undef, 1, 1)

         #read!(filename, recl)

        io = open(filename,"r")

        #open(filename) do file
        recl = read(io, Int32)

        for i=1:80
                read(io, Char)
        end

        #end


        seekstart(io)
        seek(io, 4*recl)

        for i=1:10
                read(io, Char)
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

        return pressure, Pos_r_r, Pos_r_z
end
