## -------------------------------------------------------------------
# extras interface
get_extra(net::MetNet) = net.extras

## -------------------------------------------------------------------
# net interface
# TODO: see how we can define 'reactions, etc' without colliding with COBREXA
export matrix_type
matrix_type(::MetNet{MT, VT}) where {MT, VT} = MT
export vector_type
vector_type(::MetNet{MT, VT}) where {MT, VT} = VT

import COBREXA.metabolites
export metabolites
metabolites(net::MetNet) = net.mets
metabolites(net::MetNet, ider) = net.mets[metindex(net, ider)]

export eachmets
eachmets(net) = eachindex(metabolites(net))

import COBREXA.reactions
export reactions
reactions(net::MetNet) = net.rxns
reactions(net::MetNet, ider) = net.rxns[rxnindex(net, ider)]

export eachrxn
eachrxn(net) = eachindex(reactions(net))

import COBREXA.genes
export genes
genes(net::MetNet) = net.genes
genes(net::MetNet, ider) = net.genes[geneindex(net, ider)]

export eachrxn
eachgenes(net) = eachindex(genes(net))

export rxnrange
rxnrange(net) = (ub(net) .- lb(net))
rxnrange(net, ider) = (idx = rxnindex(net, ider); ub(net, idx) .- lb(net, idx))

export ub
ub(net::MetNet) = net.ub
ub(net::MetNet, ider) = net.ub[rxnindex(net, ider)]

export lb
lb(net::MetNet) = net.lb
lb(net::MetNet, ider) = net.lb[rxnindex(net, ider)]

export balance
import COBREXA.balance
balance(net::MetNet) = net.b
balance(net::MetNet, ider) = net.b[metindex(net, ider)]

export stoi
stoi(net::MetNet) = net.S
stoi(net::MetNet, metider, rxnider) = net.S[metindex(net, metider), rxnindex(net, rxnider)]
    
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

export lin_objective, lin_objective!
lin_objective(net::MetNet) = net.c
lin_objective(net::MetNet, ider) = net.c[rxnindex(net, ider)]
function lin_objective!(net::MetNet, ider, val) 
    _setindex!(net.c, zero(eltype(net.c)))
    idxs = rxnindex(net, ider)
    _setindex!(net.c, idxs, val)
    return net.c
end
lin_objective!(net::MetNet, val) = lin_objective!(net, Colon(), val) 

metnet(net::MetNet) = net