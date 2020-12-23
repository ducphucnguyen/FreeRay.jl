export Analysis


abstract type Options end


"""
    Analysis
Set-up analysis parameters.
### Fields:
* `filename`    - unique filename of the model.
* `analyse`     - R, C, I, G, B stand for ray, coheren, incoherence, geometri and gaussian
* `num_ray`     - number of rays.
* `alpha`       - ray lauch angles between -90 and 90 deg.
* `box`         - analysis box x- range, km and y-depth, m.
### Available Constructors:
* `Source(;frequency::Real = 1000.0f0, height::Real = 80.0f0))`
* `Source(frequency, height)`
"""
struct Analysis{T<:AbstractArray} <: Options
    filename::String
    analyse::String
    option1::String
    option2::String
    num_ray::Int
    alpha::Vec2{T}
    box::Vec2{T}
    step::Real
end

Analysis(;filename = "Model_f1000Hz",
            analyse = "CB",
            option1 = "SVW",
            option2 = "A",
            num_ray = 80,
            alpha = Vec2(-80.0f0,80.0f0),
            box = Vec2(10f0,1000.0f0),
            step= 0) =
    Analysis(filename, analyse, option1, option2, num_ray, alpha, box, step)
