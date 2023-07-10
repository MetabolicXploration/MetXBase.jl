# Reduce the fixxed colums $ub = lb$
# It move any constant balance to $b$
function empty_fixxed!(lep::LEPModel; eps = 0.0, protect = [])

    protect = colindex(lep, protect)

    _, N = size(lep)

    non_protected = trues(N)
    non_protected[protect] .= false

    # up bounds
    fixxed = falses(N)
    for ri in findall(non_protected)
        if lep.lb[ri] == lep.ub[ri] # fixxed
            fixxed[ri] = iszero(eps)
            lep.lb[ri], lep.ub[ri] = (lep.lb[ri] - eps), (lep.ub[ri] + eps)
        end
    end
    
    # new balance
    lep.b .= lep.b - lep.S * (fixxed .* lep.lb)

    # del 
    empty_col!(lep, findall(fixxed))

    return lep
end

# lep interface
empty_fixxed!(model; kwargs...) = empty_fixxed!(lepmodel(model); kwargs...)