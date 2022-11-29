function nearPD!(A::AbstractMatrix, δ::Float64 = 1e-10)
    A .= 0.5 * (A + A')
    e, U = eigen(A)
    τ = max.(δ, e)
    A .= U * Diagonal(τ) * U'
    A .= 0.5 * (A + A')
    return A
end
nearPD(A::AbstractMatrix, δ::Float64 = 1e-10) = nearPD!(copy(A), δ)