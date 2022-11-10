indep_rxns(net::MetNet; kwargs...) = indep_rxns(net.S; kwargs...)

function echelonize(net::MetNet; eps = 1e-10)

    idxind, _, idxmap, IG, bnew = echelonize(net.S, net.b; eps)

    MT = matrix_type(net)
    VT = vector_type(net)
    
    Ni = length(idxind)

    net1 = MetNet(;
        S = convert(MT, IG),
        b = convert(VT, bnew),
        rxns = _index_or_nothing(net.rxns, idxmap),
        lb = _index_or_nothing(net.lb, idxmap),
        ub = _index_or_nothing(net.ub, idxmap),
        c = _index_or_nothing(net.c, idxmap),
        extras = copy(net.extras),
        mets = ["M$i" for i in 1:Ni]                # mets lost meaning 
    )

    extras!(net1, "RXNIDX_MAP", idxmap)

    return net1
end
