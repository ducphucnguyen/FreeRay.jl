export Vec2, Vec3, rmfile

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

end
