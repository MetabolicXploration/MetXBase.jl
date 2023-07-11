# A common interface for handling a LEPModel-like objects
# Method to implement 
# - lepmodel(obj)::LEPModel
# - rowids(obj)::Vector{String} accessor to rows ids
# - colids(obj)::Vector{String} accessor to columns ids

## -------------------------------------------------------------------
# default for all AbstractLEPModel
# LEP Getters

rowids(obj, ider) = rowids(obj)[rowindex(obj, ider)]
colids(obj, ider) = colids(obj)[colindex(obj, ider)]

cost_matrix(lep) = cost_matrix(lepmodel(lep))
cost_matrix(lep, rider, cider) = cost_matrix(lep)[rowindex(lep, rider), colindex(lep, cider)]

ub(lep) = ub(lepmodel(lep))
ub(lep, ider) = ub(lep)[colindex(lep, ider)]

lb(lep) = lb(lepmodel(lep))
lb(lep, ider) = lb(lep)[colindex(lep, ider)]

colrange(lep) = (ub(lep) .- lb(lep))
colrange(lep, ider) = (idx = colindex(lep, ider); ub(lep, idx) .- lb(lep, idx))

export balance # re-export
balance(lep) = balance(lepmodel(lep))
balance(lep, ider) = balance(lep)[rowindex(lep, ider)]

bounds(lep, ider) = (idx = colindex(lep, ider); (lb(lep, idx), ub(lep, idx)))

linear_weights(lep) = linear_weights(lepmodel(lep))
linear_weights(lep, ider) = linear_weights(lep)[colindex(lep, ider)]

quad_weights(lep) = quad_weights(lepmodel(lep))
quad_weights(lep, rider, cider) = quad_weights(lep)[rowindex(lep, rider), colindex(lep, cider)]
