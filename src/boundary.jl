export Reflection_Coeff

"""
    Boundary
All objects describing top and bottom reflection coefficients should be a subtype of this.
This includes three objects: Top_Reflection_Coeff and Bottom_Reflection_Coeff.
"""
abstract type Boundary end

# --------------- #
# - Reflection_Coeff - #
# --------------- #

"""
    Reflection_Coeff
Bottom and top reflection coefficients.
### Fields:
* `top_coeff`    - x-angle; y-magnitude of relection coefficient; z-phase.
* `bottom_coeff` - x-angle; y-magnitude of relection coefficient; z-phase.
### Available Constructors:
* `Reflection_Coeff(;top_coeff = Vec3(45.0f0,0.0f0,175f0),
                    bottom_coeff = Vec3(45.0f0,0.95f0,175f0))`
* `Reflection_Coeff(top_coeff, bottom_coeff)`
"""
struct Reflection_Coeff{T<:AbstractArray} <: Boundary
    top_coeff::Vec3{T}
    bottom_coeff::Vec3{T}
end

Reflection_Coeff(;top_coeff = Vec3(45.0f0,0.0f0,175f0),
                    bottom_coeff = Vec3(45.0f0,0.95f0,175f0)) =
    Reflection_Coeff(top_coeff, bottom_coeff)
