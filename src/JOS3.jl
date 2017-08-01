isdefined(Base, :__precompile__) && __precompile__()

module JOS3
    export clipdb, fold, mps
    include("./filters/filters.jl")
end
