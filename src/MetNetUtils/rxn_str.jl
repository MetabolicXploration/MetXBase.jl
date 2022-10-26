function rxn_str(net::MetNet, ider)
    ridx = rxnindex(net, ider)
    arrow_str = isblocked(net, ridx) ? " >< " : 
                isbkwd_bounded(net, ridx) ? " <== " :
                isfwd_bounded(net, ridx) ? " ==> " : " <==> " 
    
    reacts = rxn_reacts(net, ridx)
    react_str = join([string("(", stoi(net, react, ridx), ") ", 
        metabolites(net, react))  for react in reacts], " + ")
    
    prods = rxn_prods(net, ridx)
    prods_str = join([string("(", stoi(net, prod, ridx), ") ", 
        metabolites(net, prod))  for prod in prods], " + ")
    return react_str * arrow_str * prods_str
end
rxn_str(net::MetNet, iders::Vector) = [rxn_str(net, ider) for ider in iders]
rxn_str(net::MetNet) = rxn_str(net, net.rxns)