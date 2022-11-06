# Reduce the stoi matrix by del the fixxed mets
export empty_fixxed!
function empty_fixxed!(net::MetNet; eps = 0.0, protect = [])

    protect = rxnindex(net, protect)

    M, N = size(net)

    non_protected = trues(N)
    non_protected[protect] .= false

    # up bounds
    fixxed = falses(N)
    for ri in findall(non_protected)
        if net.lb[ri] == net.ub[ri] # fixxed
            fixxed[ri] = iszero(eps)
            net.ub[ri], net.lb[ri] = (net.lb[ri] - eps), (net.ub[ri] + eps)
        end
    end
    
    # balance
    net.b .= net.b - net.S * (fixxed .* net.lb)

    # del 
    empty_rxn!(net, findall(fixxed))

    return net
end