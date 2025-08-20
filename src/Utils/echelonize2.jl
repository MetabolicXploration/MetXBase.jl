
function basis_rxns(S::DenseMatrix, b::DenseVector; 
        tol::Float64 = 1e-10,
        include = nothing, # TODO: implement this (try to include the given cols in the independent set)
        verbose = false
    )

    Ab = hcat(S, b)
    _, idxd = _rref!(Ab; tol, verbose)
    return idxd
end

basis_rxns(S::AbstractMatrix, b::AbstractVector; kwargs...) = basis_rxns(_dense(S), _dense(b); kwargs...)

# make so that
# vi = rand(Ni)
# vd = be - G * vi
# v = zeros(N)
# v[idxi] = vi
# v[idxd] = vd
# @assert sum(S * v) < 1e-5
# Note that a full lepmodel feasibility is also dependent on lb, ub
# So G * vi = be, lbi \le vi \le ubi is not sufficient, you need to test lbd \le vi \le ubd
function echelonize(S::DenseMatrix, b::DenseVector; tol::Real = 1e-10, verbose = false)

    # @info "echelonize2"

    M, N = size(S)
    @assert M <= N
    Ab = hcat(S, b)
    A, idxd = _rref!(Ab; tol, verbose)
    Nd = length(idxd)
    A = view(A, 1:Nd, :)
    idxi = setdiff(1:N, idxd)
    Nf = length(idxi)
    G = A[:, idxi]
    be = A[:, end]
    idxmap = vcat(idxd, idxi)

    return idxi, idxd, idxmap, G, be

end

echelonize(X::AbstractMatrix, b::AbstractVector; tol::Real = 1e-10, verbose = false) = 
    echelonize(_dense(X), _dense(b); tol, verbose)

function basis_mat(G::Matrix, idxi::Vector, idxd::Vector)
    Nf, Nd = length(idxi), length(idxd)
    basis = zeros(Nd + Nf, Nf)
    basis[idxd, :] = -G
    # basis[idxi, :] = Matrix(I, Nf, Nf)
    c1 = one(eltype(basis))
    @inbounds for (i, f) in enumerate(idxi)
        basis[f, i] = c1
    end
    return basis
end

# TODO: Implement pivoting. Right now we can not control the set of independent 
# colums which is selected. It can even be the last column, 
# which in a net extended matrix (Sb) is not a flux column.

# Derived from https://github.com/blegat/RowEchelon.jl
function _rref!(A::DenseArray; tol::Float64=1e-10, verbose = false)

    T = eltype(A)
    nr, nc = size(A)
    idxd = Int[]
    i = j = 1
    verbose && (prog = ProgressThresh(0; dt = 0.1, desc = "_rref! ", showspeed = true);)
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
            for k = j:nc
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
        verbose && update!(prog, min(nr - i, nc - j); 
            showvalues = [(:row, i), (:column, j), (:idxd_len, length(idxd))]
        )
    end
    verbose && finish!(prog)

    return A, idxd
end
