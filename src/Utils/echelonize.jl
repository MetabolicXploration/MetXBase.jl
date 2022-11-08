# Code derived from metabolicEP (https://github.com/anna-pa-m/Metabolic-EP)

export indep_rxns
function indep_rxns(X::AbstractMatrix; 
        eps::Float64 = 1e-10,
        include = nothing # TODO: implement this (try to include the given cols in the independent set)
    )

    sum(abs2,X) == 0 && return Int[]
    _,R,E = qr(X, ColumnNorm())
    diagr = diag(R)
    diagr1 = abs(first(diagr))
    r = findlast(abs.(diagr) .>= eps * diagr1)
    isnothing(r) && return Int[]
    idx = sort(view(E, 1:r))
    return idx

end

export echelonize
function echelonize(X::T, v; 
        eps::Real = 1e-10
    ) where T <:DenseArray

    _, N = size(X)
    c0 = zero(eltype(X))
    c1 = one(eltype(X))

    idxrow = indep_rxns(Matrix(X'))
    Mred = length(idxrow)

    idxind = indep_rxns(X; eps)
    idxdep = setdiff(1:N, idxind)
    idxmap = vcat(idxind, idxdep)
    Tv = @view X[idxrow, idxmap]
    iTv = inv(Tv[1:Mred, 1:Mred])
    IG = iTv * Tv
    # trimming zeros
    for i in eachindex(IG)
        abs(IG[i]) < eps && (IG[i] = c0)
    end
    bnew = iTv * v[idxrow]
    # trimming ones
    for i in 1:Mred
        abs(1.0 - IG[i,i]) < eps && (IG[i,i] = c1)
    end

    return idxind, idxdep, idxmap, IG, bnew

end

echelonize(X::AbstractMatrix, v; eps::Real = 1e-10) = echelonize(Matrix(X), v; eps)