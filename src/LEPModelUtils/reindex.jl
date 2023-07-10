# TODO: makes a general reindex interface
function reindex(lep::LEPModel, rowids, colids)

    colids = colindex(lep, colids)
    rowids = rowindex(lep, rowids)

    lepd = Dict()

    # row stuff
    lepd[:rowids] = _getindex_or_nothing(lep.rowids, rowids)
    lepd[:b] = _getindex_or_nothing(lep.b, rowids)
    
    # col stuff
    lepd[:colids] = _getindex_or_nothing(lep.colids, colids)
    lepd[:c] = _getindex_or_nothing(lep.c, colids)
    lepd[:lb] = _getindex_or_nothing(lep.lb, colids)
    lepd[:ub] = _getindex_or_nothing(lep.ub, colids)

    # row x col stuff
    lepd[:S] = _getindex_or_nothing(lep.S, rowids, colids)
    lepd[:C] = _getindex_or_nothing(lep.C, rowids, colids)
    
    lepd[:extras] = lep.extras
    
    return  LEPModel(; lepd...)
end

# LEP interface
reindex(obj, args...) = reindex(lepmodel(obj), args...) 