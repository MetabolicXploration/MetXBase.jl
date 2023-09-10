isreversible(lep, ider) = (indx = colindex(lep, ider); 
            lb(lep)[indx] < 0.0 && ub(lep)[indx] > 0.0)

isblocked(lep, ider) = (indx = colindex(lep, ider); 
    lb(lep)[indx] == 0.0 && ub(lep)[indx] == 0.0)

import Base.isopen
isopen(lep, ider) = !isblocked(lep, ider)

isfwd_bounded(lep, ider) = (indx = colindex(lep, ider); 
    lb(lep)[indx] >= 0.0 && ub(lep)[indx] > 0.0)

isbkwd_bounded(lep, ider) = (indx = colindex(lep, ider); 
    lb(lep)[indx] < 0.0 && ub(lep)[indx] <= 0.0)

isfwd_defined(lep, ider) = (indx = colindex(lep, ider); 
    length(rxn_reacts(lep, indx)) > 0)

isbkwd_defined(lep, ider) = (indx = colindex(lep, ider); 
    length(rxn_prods(lep, indx)) > 0) 

isfixxed(lep, ider) = (indx = colindex(lep, ider); 
    lb(lep)[indx] == ub(lep)[indx] != 0.0)

reversibles(lep) = findall((lb(lep) .< 0.0) .& (ub(lep) .> 0.0))
revscount(lep) = length(reversibles(lep))

blocks(lep) = findall((lb(lep) .== 0.0) .& (ub(lep) .== 0.0))
blockscount(lep) = length(blocks(lep))

fwds_bounded(lep) = findall((lb(lep) .>= 0.0) .& (ub(lep) .> 0.0))
fwds_boundedcount(lep) = length(fwds_bounded(lep))

bkwds_bounded(lep) = findall((lb(lep) .< 0.0) .& (ub(lep) .<= 0.0))
bkwds_boundedcount(lep) = length(bkwds_bounded(lep))

fixxeds(lep) = findall((lb(lep) .== ub(lep) .&& lb(lep) .!= 0.0))
fixxedscount(lep) = length(fixxeds(lep))

allfwd(lep) = fwds_boundedcount(lep) == rxnscount(lep)
