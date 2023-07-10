echelonize(lep::LEPModel; tol = 1e-10, verbose = false) = echelonize(lep.S, lep.b; tol, verbose)

function echelcols(lep::LEPModel; tol = 1e-10, verbose = false)
    idxi, idxd, _, _, _ = echelonize(lep; tol, verbose)
    return idxi, idxd
end

# returns the independent columns
indcols(lep::LEPModel; tol = 1e-10, verbose = false) = first(echelcols(lep; tol, verbose))

# returns the dependent columns
depcols(lep::LEPModel; tol = 1e-10, verbose = false) = last(echelcols(lep; tol, verbose))


