# # Code derived from metabolicEP (https://github.com/anna-pa-m/Metabolic-EP)

# export basis_rxns
# function basis_rxns(X::AbstractMatrix; 
#         tol::Float64 = 1e-10,
#         include = nothing # TODO: implement this (try to include the given cols in the independent set)
#     )

#     sum(abs2,X) == 0 && return Int[]
#     _,R,E = qr(X, ColumnNorm())
#     diagr = diag(R)
#     diagr1 = abs(first(diagr))
#     r = findlast(abs.(diagr) .>= tol * diagr1)
#     isnothing(r) && return Int[]
#     idx = sort(view(E, 1:r))
#     return idx

# end

# basis_rxns(S::AbstractMatrix, b::AbstractVector; kwargs...) = basis_rxns(_dense(S), _dense(b); kwargs...)

# export echelonize
# function echelonize(X::DenseMatrix, v::DenseVector; 
#         tol::Real = 1e-10
#     )

#     @info "echelonize"

#     _, N = size(X)
#     c0 = zero(eltype(X))
#     c1 = one(eltype(X))

#     idxrow = basis_rxns(Matrix(X'))
#     Mred = length(idxrow)

#     idxd = basis_rxns(X; tol)
#     idxf = setdiff(1:N, idxd)
#     idxmap = vcat(idxd, idxf)
#     Tv = @view X[idxrow, idxmap]
#     iTv = inv(Tv[1:Mred, 1:Mred])
#     IG = iTv * Tv
#     # trimming zeros
#     for i in eachindex(IG)
#         abs(IG[i]) < tol && (IG[i] = c0)
#     end
#     bnew = iTv * v[idxrow]
#     # trimming ones
#     for i in 1:Mred
#         abs(1.0 - IG[i,i]) < tol && (IG[i,i] = c1)
#     end
    
#     G = IG[:, (length(idxd) + 1):end]
#     basis = zeros(0,0) # TODO: compute the basis

#     return idxf, idxd, idxmap, G, bnew, basis

# end

# echelonize(X::AbstractMatrix, v::AbstractVector; tol::Real = 1e-10) = echelonize(_dense(X), _dense(v); tol)

# function basis_mat(G::Matrix, idxf::Vector, idxd::Vector)
#     Nf, Nd = length(idxf), length(idxd)
#     basis = zeros(Nd + Nf, Nf)
#     basis[idxd, :] = -G
#     # basis[idxf, :] = Matrix(I, Nf, Nf)
#     c1 = one(eltype(basis))
#     @inbounds for (i, f) in enumerate(idxf)
#         basis[f, i] = c1
#     end
#     return basis
# end