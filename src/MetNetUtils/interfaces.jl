# extras interface
get_extra(net::MetNet) = net.extras

# net interface
export metabolites
metabolites(net::MetNet) = net.mets
metabolites(net::MetNet, ider) = net.mets[metindex(net, ider)]

export reactions
reactions(net::MetNet) = net.rxns
reactions(net::MetNet, ider) = net.rxns[rxnindex(net, ider)]

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
balance(net::MetNet) = net.b
balance(net::MetNet, ider) = net.b[metindex(net, ider)]

export stoi
stoi(net::MetNet) = net.S
stoi(net::MetNet, metider, rxnider) = net.S[metindex(net, metider), rxnindex(net, rxnider)]
    