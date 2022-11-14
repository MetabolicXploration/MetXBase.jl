export reindex
function reindex(net::MetNet;
        met_idxs = Colon(), 
        rxn_idxs = Colon(),
        genes_idxs = Colon(),
    )

    # TODO: find where rxnGeneMat goes
    
    rxn_idxs = rxnindex(net, rxn_idxs)
    met_idxs = metindex(net, met_idxs)
    genes_idxs = geneindex(net, genes_idxs)

    netd = Dict()

    netd[:mets] = _getindex_or_nothing(net.mets, met_idxs)
    netd[:metNames] = _getindex_or_nothing(net.metNames, met_idxs)
    netd[:metFormulas] = _getindex_or_nothing(net.metFormulas, met_idxs)
    netd[:b] = _getindex_or_nothing(net.b, met_idxs)
    
    netd[:rxns] = _getindex_or_nothing(net.rxns, rxn_idxs)
    netd[:rxnNames] = _getindex_or_nothing(net.rxnNames, rxn_idxs)
    netd[:c] = _getindex_or_nothing(net.c, rxn_idxs)
    netd[:lb] = _getindex_or_nothing(net.lb, rxn_idxs)
    netd[:ub] = _getindex_or_nothing(net.ub, rxn_idxs)
    netd[:subSystems] = _getindex_or_nothing(net.rxnNames, rxn_idxs)
    netd[:grRules] = _getindex_or_nothing(net.grRules, rxn_idxs)

    netd[:genes] = _getindex_or_nothing(net.genes, genes_idxs)

    netd[:S] = _getindex_or_nothing(net.S, met_idxs, rxn_idxs)

    return MetNet(; netd...)
end