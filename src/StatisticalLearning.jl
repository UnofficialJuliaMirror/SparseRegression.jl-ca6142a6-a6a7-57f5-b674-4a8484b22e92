module StatisticalLearning

import StatsBase

export
    StatLearnPath,
    NoPenalty, RidgePenalty, LassoPenalty, ElasticNetPenalty, SCADPenalty,
    L2Regression, L1Regression, LogisticRegression, SVMLike, QuantileRegression,
    HuberRegression

#-----------------------------------------------------------------------------# types
typealias VecF Vector{Float64}
typealias MatF Matrix{Float64}
typealias AVec{T} AbstractVector{T}
typealias AMat{T} AbstractMatrix{T}
typealias AVecF AVec{Float64}
typealias AMatF AMat{Float64}

#--------------------------------------------------------------------------# printing
print_header(io::IO, s::AbstractString) = print_with_color(:blue, io, "■ $s \n")
function print_item(io::IO, name::AbstractString, value)
    println(io, "  >" * @sprintf("%12s", name * ": "), value)
end


#----------------------------------------------------------------------# source files
include("penalty.jl")
include("model.jl")
include("statlearnpath.jl")
include("algorithms/fista.jl")

end # module
s = StatisticalLearning
