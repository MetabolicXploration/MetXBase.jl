# A common interface for accessing the network
# The methods to be implemented are the accessors (e.g. metabolites)

export mets_count
mets_count(net) = length(metabolites(net))

export rxns_count
rxns_count(net) = length(reactions(net))

export genes_count
genes_count(net) = length(genes(net))