export resize
function resize(net::MetNet;
        nmets = _length_or_nothing(net.mets),
        nrxns = _length_or_nothing(net.rxns),
        ngenes = _length_or_nothing(net.genes),
    )

    netd = Dict()

    if !isnothing(nmets)
        netd[:mets] = _resize_or_nothing(net.mets, EMPTY_SPOT, nmets)
        netd[:metNames] = _resize_or_nothing(net.metNames, EMPTY_SPOT, nmets)
        # TODO: handle all the cases
        # netd[:metFormulas] = _resize_or_nothing(net.metFormulas, EMPTY_SPOT, nmets)
        netd[:b] = _resize_or_nothing(net.b, 0.0, nmets)
    end
    
    if !isnothing(nrxns)
        netd[:rxns] = _resize_or_nothing(net.rxns, EMPTY_SPOT, nrxns)
        netd[:rxnNames] = _resize_or_nothing(net.rxnNames, EMPTY_SPOT, nrxns)
        netd[:c] = _resize_or_nothing(net.c, 0.0, nrxns)
        netd[:lb] = _resize_or_nothing(net.lb, 0.0, nrxns)
        netd[:ub] = _resize_or_nothing(net.ub, 0.0, nrxns)
        netd[:subSystems] = _resize_or_nothing(net.rxnNames, EMPTY_SPOT, nrxns)
        netd[:grRules] = _resize_or_nothing(net.grRules, EMPTY_SPOT, nrxns)
    end

    if !isnothing(ngenes)
        netd[:genes] = _resize_or_nothing(net.genes, EMPTY_SPOT, ngenes)
    end
    
    if !isnothing(nmets) && !isnothing(nrxns)
        netd[:S] = _resize_or_nothing(net.S, 0.0, nmets, nrxns)
    end
    
    netd[:extras] = net.extras
    
    return  MetNet(; netd...)
end