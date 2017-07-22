isdefined(Base, :__precompile__) && __precompile__()

module JOS3
    export clipdb, fold, mps
    include("./filters/clipdb.jl")
    include("./filters/fold.jl")
    include("./filters/mps.jl")
end
