# This file is not included.  Just working out thoughts on combining link/loss
# note: lossderiv is derivative with respect to η

abstract Model

# =====================================================================# LinPredModel
abstract LinPredModel <: Model # Models that make predictions from f(η) where η = Xβ
function lossvector!(m::LinPredModel, storage::VecF, y::VecF, η::VecF)
    for i in eachindex(y)
        @inbounds storage[i] = loss(m, y[i], η[i])
    end
end

#----------------------------------------------------------------------# L2Regression
immutable L2Regression <: LinPredModel end
loss(m::L2Regression, y::Float64, η::Float64) = 0.5 * (y - η) ^ 2
lossderiv(m::L2Regression, y::Float64, η::Float64) = -(y - η)
predict!(m::L2Regression, storage::VecF, η::VecF) = copy!(storage, η)

#----------------------------------------------------------------------# L1Regression
immutable L1Regression <: LinPredModel end
loss(m::L1Regression, y::Float64, η::Float64) = abs(y - η)
lossderiv(m::L1Regression, y::Float64, η::Float64) = -sign(y - η)
predict!(m::L1Regression, storage::VecF, η::VecF) = copy!(storage, η)

#----------------------------------------------------------------# LogisticRegression
immutable LogisticRegression <: LinPredModel end
loss(m::LogisticRegression, y::Float64, η::Float64) = log(1.0 + exp(-y * η))
lossderiv(m::LogisticRegression, y::Float64, η::Float64) = -y / (1.0 + exp(y * η))
function predict!(m::LogisticRegression, storage::VecF, η::VecF)
    @assert length(storage) == length(η) "Check that @inbounds is safe"
    for i in eachindex(storage)
        @inbounds storage[i] = 1.0 / (1.0 + exp(-η[i]))
    end
end

#---------------------------------------------------------------------------# SVMLike
immutable SVMLike <: LinPredModel end
loss(m::SVMLike, y::Float64, η::Float64) = max(0.0, 1.0 - y * η)
lossderiv(m::SVMLike, y::Float64, η::Float64) = 1.0 < y*η ? 0.0: -y
predict!(m::SVMLike, storage::VecF, η::VecF) = copy!(storage, η)

#----------------------------------------------------------------# QuantileRegression
immutable QuantileRegression <: LinPredModel τ::Float64 end
function loss(m::QuantileRegression, y::Float64, η::Float64)
    r = y - η
    r * (m.τ - (r < 0.0))
end
lossderiv(m::QuantileRegression, y::Float64, η::Float64) = (y - η < 0.0) - m.τ
predict!(m::QuantileRegression, storage::VecF, η::VecF) = copy!(storage, η)
