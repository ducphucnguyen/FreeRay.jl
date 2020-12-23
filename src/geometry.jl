export Source, Receiver, Terrain

# ----- #
# Geometry #
# ----- #

"""
    Geometry
All objects describing the model geometry should be a subtype of this.
This includes three objects: Source, Reciver and Terrain.
"""
abstract type Geometry end


# --------------- #
# - Source - #
# --------------- #

"""
    Source
A source of sound which emits sound rays from a point in 2D space.
### Fields:
* `frequency`  - Hz, frequency of source sound emitted from the source.
* `height`     - m, height of the sound source above local ground level.
### Available Constructors:
* `Source(;frequency::Real = 1000.0f0, height::Real = 80.0f0))`
* `Source(frequency, height)`
"""
struct Source{T<:Real} <: Geometry
    frequency::T
    height::T
end

Source(;frequency::Real = 1000.0f0, height::Real = 80.0f0) =
    Source(frequency, height)



# --------------- #
# - Receiver - #
# --------------- #

"""
    Receiver
Multiple receiver in 2D space.
### Fields:
* `depth_point`  - Number of gird points along depth (or height).
* `range_point`  - Number of gird points along propagation range.
* `depth`        - from lowest to highest depth.
* `range`  - from source to receiver.
### Available Constructors:
* `Receiver(;depth_point::Int = 100,
            range_point::Int = 1000,
             depth = Vec2(0.0f0, 1.0f0),
             range = Vec2(0.0f0, 1.0f0))`
* `Receiver(depth_point, range_point, depth,range)`
"""
struct Receiver{T<:AbstractArray} <: Geometry
    depth_point:: Int
    range_point:: Int
    depth::Vec2{T}
    range::Vec2{T}
end

Receiver(;depth_point::Int = 100,
            range_point::Int = 1000,
             depth = Vec2(0.0f0, 1.0f0),
             range = Vec2(0.0f0, 1.0f0)) =
 Receiver(depth_point, range_point, depth,range)



 # --------------- #
 # - Terrain - #
 # --------------- #

 """
     Terrain
 Elevation profile.
 ### Fields:
 * `interp_type`    - Interpolation method 'L' for piecewise linear fit and
                    'C' for a curvilinear fit.
 * `profile`        - x- range in km and y-elevation in m.
 ### Available Constructors:
 * `Terrain(;interp_type::String = "L",
              profile = Vec2(0.0f0, 1.0f0))`
 * `Terrain(interp_type, profile)`
 """
struct Terrain{T<:AbstractArray} <: Geometry
    interp_type::String
    profile::Vec2{T}
end

Terrain(;interp_type::String = "L",
             profile = Vec2(0.0f0, 1.0f0)) =
 Terrain(interp_type, profile)
