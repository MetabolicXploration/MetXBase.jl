# Fundamentals

rowids(lep::LEPModel) = lep.rowids
rowids(lep::LEPModel, ider) = lep.rowids[rowindex(lep, ider)]

colids(lep::LEPModel) = lep.colids
colids(lep::LEPModel, ider) = lep.colids[colindex(lep, ider)]

## -------------------------------------------------------------------
# LEP Getters
cost_matrix(lep) = lep.S
cost_matrix(lep, rider, cider) = lep.S[rowindex(lep, rider), colindex(lep, cider)]

colrange(lep) = (ub(lep) .- lb(lep))
colrange(lep, ider) = (idx = colindex(lep, ider); ub(lep, idx) .- lb(lep, idx))

ub(lep) = lep.ub
ub(lep, ider) = lep.ub[colindex(lep, ider)]

lb(lep) = lep.lb
lb(lep, ider) = lep.lb[colindex(lep, ider)]

export balance
balance(lep) = lep.b
balance(lep, ider) = lep.b[rowindex(lep, ider)]

bounds(lep, ider) = (idx = colindex(lep, ider); (lb(lep, idx), ub(lep, idx)))

# TODO: rename to reflect that it is for optimizations
linear_coefficients(lep) = lep.c
linear_coefficients(lep, ider) = lep.c[colindex(lep, ider)]

quad_coefficients(lep) = lep.C
quad_coefficients(lep, rider, cider) = lep.C[rowindex(lep, rider), colindex(lep, cider)]

## -------------------------------------------------------------------
# LEP Setters
cost_matrix!(lep, rider, cider, val) =  
    (_setindex!(lep.S, rowindex(lep, rider), colindex(lep, cider), val); lep)

balance!(lep, rider, val) = 
    (_setindex!(lep.b, rowindex(lep, rider), val); lep)

ub!(lep, cider, val) = 
    (_setindex!(lep.ub, colindex(lep, cider), val); lep)
ub!(lep, val) = 
    (_setindex!(lep.ub, Colon(), val); lep)

lb!(lep, cider, val) = 
    (_setindex!(lep.lb, colindex(lep, cider), val); lep)
lb!(lep, val) = 
    (_setindex!(lep.lb, Colon(), val); lep)

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

# TODO: rename to reflect that it is for optimizations
function linear_coefficients!(lep, ider, val) 
    _setindex!(lep.c, zero(eltype(lep.c)))
    idxs = colindex(lep, ider)
    _setindex!(lep.c, idxs, val)
    return lep.c
end
linear_coefficients!(lep, val) = linear_coefficients!(lep, Colon(), val) 

quad_coefficients!(lep, rider, cider, val) =  
    (_setindex!(lep.C, rowindex(lep, rider), colindex(lep, cider), val); lep)

## -------------------------------------------------------------------
# Utils
matrix_type(::LEPModel{MT, VT}) where {MT, VT} = MT
vector_type(::LEPModel{MT, VT}) where {MT, VT} = VT
