export SSP

"""
    Atmostphere
All objects describing atmospheric condtions should be a subtype of this.
This includes objects: SSP
"""
abstract type Atmosphere end



# --------------- #
# - SSP - #
# --------------- #

"""
    SSP
Sound speed profile.
### Fields:
* `sound_speed_profile`  - x-depth, y-sound speed.
### Available Constructors:
* `SSP(;sound_speed_profile= Vec2(10.0f0, 10.0f0))`
* `SSP(sound_speed_profile)`
"""
struct SSP{T<:AbstractArray} <: Atmosphere
    sound_speed_profile::Vec2{T}
end

SSP(;sound_speed_profile= Vec2(10.0f0, 10.0f0)) =
    SSP(sound_speed_profile)
