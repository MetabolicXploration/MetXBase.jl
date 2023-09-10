function col_str(lep, ider)
    cidx = colindex(lep, ider)
    arrow_str = isblocked(lep, cidx) ? " >< " : 
                isbkwd_bounded(lep, cidx) ? " <== " :
                isfwd_bounded(lep, cidx) ? " ==> " : " <==> " 
    
    negs = col_negcost(lep, cidx)
    neg_str = join([string("(", cost_matrix(lep, neg, cidx), ") ", 
        rowids(lep, neg)) for neg in negs], " + ")
    
    poss = col_poscost(lep, cidx)
    pos_str = join([string("(", cost_matrix(lep, pos, cidx), ") ", 
        rowids(lep, pos))  for pos in poss], " + ")
    return neg_str * arrow_str * pos_str
end
col_str(lep, iders::Vector) = [col_str(lep, ider) for ider in iders]
col_str(lep) = col_str(lep, colids(lep))