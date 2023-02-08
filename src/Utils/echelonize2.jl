export basis_rxns
function basis_rxns(S::DenseMatrix, b::DenseVector; 
        tol::Float64 = 1e-10,
        include = nothing # TODO: implement this (try to include the given cols in the independent set)
    )

    Ab = hcat(S, b)
    _, idxd = _rref!(Ab; tol)
    return idxd
end

basis_rxns(S::AbstractMatrix, b::AbstractVector; kwargs...) = basis_rxns(_dense(S), _dense(b); kwargs...)

export echelonize 
function echelonize(X::DenseMatrix, v::DenseVector; tol::Real = 1e-10)

    # @info "echelonize2"

    M, N = size(X)
    @assert M <= N
    Ab = hcat(X, v)
    A, idxd = _rref!(Ab; tol)
    Nd = length(idxd)
    A = view(A, 1:Nd, :)
    idxf = setdiff(1:N, idxd)
    Nf = length(idxf)
    G = A[:, idxf]
    be = A[:, end]
    idxmap = vcat(idxd, idxf)

    return idxf, idxd, idxmap, G, be

end

echelonize(X::AbstractMatrix, v::AbstractVector; tol::Real = 1e-10) = echelonize(_dense(X), _dense(v); tol)

function basis_mat(G::Matrix, idxf::Vector, idxd::Vector)
    Nf, Nd = length(idxf), length(idxd)
    basis = zeros(Nd + Nf, Nf)
    basis[idxd, :] = -G
    # basis[idxf, :] = Matrix(I, Nf, Nf)
    c1 = one(eltype(basis))
    @inbounds for (i, f) in enumerate(idxf)
        basis[f, i] = c1
    end
    return basis
end

# TODO: Implement pivoting. Right now we can not control the set of independent 
# colums which is selected. It can even be the last column, 
# which in a net extended matrix (Sb) is not a flux column.

# Derived from https://github.com/blegat/RowEchelon.jl
function _rref!(A::DenseArray; tol::Float64=1e-10)

    T = eltype(A)
    nr, nc = size(A)
    idxd = Int[]
    i = j = 1
    @inbounds while i <= nr && j <= nc
        (m, mi) = findmax(abs, view(A, i:nr, j))
        mi = mi+i - 1
        if m <= tol
            if tol > 0
                A[i:nr,j] .= zero(T)
            end
            j += 1
        else
            push!(idxd, j) 
            for k=j:nc
                A[i, k], A[mi, k] = A[mi, k], A[i, k]
            end
            d = A[i,j]
            for k = j:nc
                A[i,k] /= d
            end
            for k = 1:nr
                if k != i
                    d = A[k,j]
                    for l = j:nc
                        A[k,l] -= d*A[i,l]
                    end
                end
            end
            i += 1
            j += 1
        end
    end
    return A, idxd
end
