isdefined(Base, :__precompile__) && __precompile__()

module JOS3
    export clipdb,
           check_gradient,
           check_hessian,
           check_second_derivative,
           deparse,
           derivative,
           differentiate,
           hessian,
           jacobian,
           second_derivative
    include("filters/clipdb.jl")
    include("filters/fold.jl")
    include("filters/mps.jl")    
end
