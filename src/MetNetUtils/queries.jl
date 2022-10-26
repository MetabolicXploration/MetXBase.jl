isrev(net::MetNet, ider) = (indx = rxnindex(net, ider); 
            net.lb[indx] < 0.0 && net.ub[indx] > 0.0)

isblocked(net::MetNet, ider) = (indx = rxnindex(net, ider); 
    net.lb[indx] == 0.0 && net.ub[indx] == 0.0)

isopen(net::MetNet, ider) = !isblocked(net::MetNet, ider)

isfwd_bounded(net::MetNet, ider) = (indx = rxnindex(net, ider); 
    net.lb[indx] >= 0.0 && net.ub[indx] > 0.0)

isbkwd_bounded(net::MetNet, ider) = (indx = rxnindex(net, ider); 
    net.lb[indx] < 0.0 && net.ub[indx] <= 0.0)

isfwd_defined(net::MetNet, ider) = (indx = rxnindex(net, ider); 
    length(rxn_reacts(net, indx)) > 0)

isbkwd_defined(net::MetNet, ider) = (indx = rxnindex(net, ider); 
    length(rxn_prods(net, indx)) > 0) 

isfixxed(net::MetNet, ider) = (indx = rxnindex(net, ider); 
    net.lb[indx] == net.ub[indx] != 0.0)

revs(net::MetNet) = findall((net.lb .< 0.0) .& (net.ub .> 0.0))
revscount(net::MetNet) = length(revs(net))

blocks(net::MetNet) = findall((net.lb .== 0.0) .& (net.ub .== 0.0))
blockscount(net::MetNet) = length(blocks(net))

fwds_bounded(net::MetNet) = findall((net.lb .>= 0.0) .& (net.ub .> 0.0))
fwds_boundedcount(net::MetNet) = length(fwds_bounded(net))

bkwds_bounded(net::MetNet) = findall((net.lb .< 0.0) .& (net.ub .<= 0.0))
bkwds_boundedcount(net::MetNet) = length(bkwds_bounded(net))

fixxeds(net::MetNet) = findall((net.lb .== net.ub .!= 0.0))
fixxedscount(net::MetNet) = length(fixxeds(net))

allfwd(net::MetNet) = fwds_boundedcount(net) == rxnscount(net)

# TODO: Make a full exchange discovery system
function is_exchange(net::MetNet, ider)
    reacts = rxn_reacts(net, ider)
    prods = rxn_prods(net, ider)
    return xor(isempty(reacts), isempty(prods))
end
exchanges(net::MetNet) = findall(x -> is_exchange(net, x), net.rxns)
exchangescount(net::MetNet) = length(exchanges(net))