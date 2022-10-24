# A common interface for accessing the network
# The methods to be implemented are the accessors (e.g. metabolites)

export mets_count
mets_count(net) = length(metabolites(net))

export rxns_count
rxns_count(net) = length(reactions(net))

export genes_count
genes_count(net) = length(genes(net))

export bounds
bounds(net::MetNet, ider) = (idx = rxnindex(net, ider); (lb(net, idx), ub(net, idx)))

export rxn_mets
rxn_mets(net::MetNet, ider) = findall(stoi(net, :,rxnindex(net, ider)) .!= 0.0)
export rxn_reacts
rxn_reacts(net::MetNet, ider) = findall(stoi(net, :,rxnindex(net, ider)) .< 0.0)
export rxn_prods
rxn_prods(net::MetNet, ider) = findall(stoi(net, :,rxnindex(net, ider)) .> 0.0)

export met_rxns
met_rxns(net::MetNet, ider) = findall(stoi(net, metindex(net, ider), :) .!= 0.0)


