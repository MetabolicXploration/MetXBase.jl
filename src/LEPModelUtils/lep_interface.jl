# Fundamentals

lepmodel(lep::LEPModel) = lep

rowids(lep::LEPModel) = lep.rowids

colids(lep::LEPModel) = lep.colids

## -------------------------------------------------------------------
# LEP Getters
cost_matrix(lep::LEPModel) = lep.S
ub(lep::LEPModel) = lep.ub
lb(lep::LEPModel) = lep.lb
balance(lep::LEPModel) = lep.b
linear_weights(lep::LEPModel) = lep.c
quad_weights(lep::LEPModel) = lep.C

## -------------------------------------------------------------------
# LEP Setters
cost_matrix!(lep::LEPModel, rider, cider, val) =  
    (_setindex!(lep.S, rowindex(lep, rider), colindex(lep, cider), val); lep)

balance!(lep::LEPModel, rider, val) = 
    (_setindex!(lep.b, rowindex(lep, rider), val); lep)

ub!(lep::LEPModel, cider, val) = 
    (_setindex!(lep.ub, colindex(lep, cider), val); lep)
ub!(lep::LEPModel, val) = 
    (_setindex!(lep.ub, Colon(), val); lep)

lb!(lep::LEPModel, cider, val) = 
    (_setindex!(lep.lb, colindex(lep, cider), val); lep)
lb!(lep::LEPModel, val) = 
    (_setindex!(lep.lb, Colon(), val); lep)

function bounds!(lep::LEPModel, ider, lb, ub)
    idx = colindex(lep, ider)
    ub!(lep, idx, ub)
    lb!(lep, idx, lb)
    return lep
end

function bounds!(lep::LEPModel, ider;
        lb = nothing,
        ub = nothing,
    )
    idx = colindex(lep, ider)
    isnothing(ub) || ub!(lep, idx, ub)
    isnothing(lb) || lb!(lep, idx, lb)
    return lep
end

# TODO: rename to reflect that it is for optimizations
function linear_weights!(lep::LEPModel, ider, val) 
    _setindex!(lep.c, zero(eltype(lep.c)))
    idxs = colindex(lep, ider)
    _setindex!(lep.c, idxs, val)
    return lep.c
end
linear_weights!(lep::LEPModel, val) = linear_weights!(lep, Colon(), val) 

quad_weights!(lep::LEPModel, rider, cider, val) =  
    (_setindex!(lep.C, rowindex(lep, rider), colindex(lep, cider), val); lep)

## -------------------------------------------------------------------
# Utils
matrix_type(::LEPModel{MT, VT}) where {MT, VT} = MT
vector_type(::LEPModel{MT, VT}) where {MT, VT} = VT
