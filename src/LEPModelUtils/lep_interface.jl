# Fundamentals

export rowids
rowids(lep::LEPModel) = lep.rowids

export colids
colids(lep::LEPModel) = lep.colids

## -------------------------------------------------------------------
# LEP Getters
export cost_matrix
cost_matrix(lep) = lep.S
cost_matrix(lep, rider, cider) = lep.S[rowindex(lep, rider), colindex(lep, cider)]

export colrange
colrange(lep) = (ub(lep) .- lb(lep))
colrange(lep, ider) = (idx = colindex(lep, ider); ub(lep, idx) .- lb(lep, idx))

export ub
ub(lep) = lep.ub
ub(lep, ider) = lep.ub[colindex(lep, ider)]

export lb
lb(lep) = lep.lb
lb(lep, ider) = lep.lb[colindex(lep, ider)]

export balance
balance(lep) = lep.b
balance(lep, ider) = lep.b[rowindex(lep, ider)]

export bounds
bounds(lep, ider) = (idx = colindex(lep, ider); (lb(lep, idx), ub(lep, idx)))

# TODO: rename
export linear_coefficients, linear_coefficients!
linear_coefficients(lep) = lep.c
linear_coefficients(lep, ider) = lep.c[colindex(lep, ider)]

# TODO: add access to lep.C

## -------------------------------------------------------------------
# LEP Setters
export cost_matrix!
cost_matrix!(lep, rider, cider, val) =  
    (_setindex!(lep.S, rowindex(lep, rider), colindex(lep, cider), val); lep)

export balance!
balance!(lep, rider, val) = 
    (_setindex!(lep.b, rowindex(lep, rider), val); lep)

export ub!
ub!(lep, cider, val) = 
    (_setindex!(lep.ub, colindex(lep, cider), val); lep)
ub!(lep, val) = 
    (_setindex!(lep.ub, Colon(), val); lep)

export lb!
lb!(lep, cider, val) = 
    (_setindex!(lep.lb, colindex(lep, cider), val); lep)
lb!(lep, val) = 
    (_setindex!(lep.lb, Colon(), val); lep)

export bounds!
function bounds!(lep, ider, lb, ub)
    idx = colindex(lep, ider)
    ub!(lep, idx, ub)
    lb!(lep, idx, lb)
    return lep
end

function bounds!(lep, ider;
        lb = nothing,
        ub = nothing,
    )
    idx = colindex(lep, ider)
    isnothing(ub) || ub!(lep, idx, ub)
    isnothing(lb) || lb!(lep, idx, lb)
    return lep
end

# TODO: rename
function linear_coefficients!(lep, ider, val) 
    _setindex!(lep.c, zero(eltype(lep.c)))
    idxs = colindex(lep, ider)
    _setindex!(lep.c, idxs, val)
    return lep.c
end
linear_coefficients!(lep, val) = linear_coefficients!(lep, Colon(), val) 

# TODO: add setter to lep.C

## -------------------------------------------------------------------
# Utils
export matrix_type
matrix_type(::LEPModel{MT, VT}) where {MT, VT} = MT
export vector_type
vector_type(::LEPModel{MT, VT}) where {MT, VT} = VT
