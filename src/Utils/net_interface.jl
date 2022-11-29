# A common interface for handling a MetNet-like object
# The methods to be implemented are the accessors (e.g. metabolites)
# metnet

export mets_count
mets_count(net) = length(metabolites(net))

export rxns_count
rxns_count(net) = length(reactions(net))

export genes_count
genes_count(net) = length(genes(net))