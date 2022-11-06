function del_iders(net::MetNet;
        met_idxs = Colon(), 
        rxn_idxs = Colon(),
        genes_idxs = Colon(),
    )

    # TODO: find where rxnGeneMat goes
    netd = Dict()

    netd[:mets] = _index_or_nothing(net.mets, met_idxs)
    netd[:metNames] = _index_or_nothing(net.metNames, met_idxs)
    netd[:metFormulas] = _index_or_nothing(net.metFormulas, met_idxs)
    netd[:b] = _index_or_nothing(net.b, met_idxs)
    
    netd[:rxns] = _index_or_nothing(net.rxns, rxn_idxs)
    netd[:rxnNames] = _index_or_nothing(net.rxnNames, rxn_idxs)
    netd[:c] = _index_or_nothing(net.c, rxn_idxs)
    netd[:lb] = _index_or_nothing(net.lb, rxn_idxs)
    netd[:ub] = _index_or_nothing(net.ub, rxn_idxs)
    netd[:subSystems] = _index_or_nothing(net.rxnNames, rxn_idxs)
    netd[:grRules] = _index_or_nothing(net.grRules, rxn_idxs)
    

    netd[:genes] = _index_or_nothing(net.genes, genes_idxs)

    netd[:S] = _index_or_nothing(net.S, met_idxs, rxn_idxs)

    return MetNet(; netd...)
end