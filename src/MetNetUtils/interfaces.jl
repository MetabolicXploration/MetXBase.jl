# extras interface
get_extra(net::MetNet) = net.extras

# TODO: see how we can define 'reactions...' without colliding with COBREXA
# net interface
import COBREXA.metabolites
export metabolites
metabolites(net::MetNet) = net.mets
metabolites(net::MetNet, ider) = net.mets[metindex(net, ider)]

import COBREXA.reactions
export reactions
reactions(net::MetNet) = net.rxns
reactions(net::MetNet, ider) = net.rxns[rxnindex(net, ider)]

import COBREXA.genes
export genes
genes(net::MetNet) = net.genes
genes(net::MetNet, ider) = net.genes[geneindex(net, ider)]

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
lin_objective!(net::MetNet, ider, val = 1.0) = (net.c[rxnindex(net, ider)] .= 1.0, net.c)