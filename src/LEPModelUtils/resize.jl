function resize(lep::LEPModel;
        nrows = _length_or_nothing(lep.rowids),
        ncols = _length_or_nothing(lep.colids),
    )

    netd = Dict()
    nrows0, ncols0 = size(lep)
    nrows = isnothing(nrows) ? size(lep, 1) : nrows
    ncols = isnothing(ncols) ? size(lep, 2) : ncols

    # row stuf
    if nrows0 != nrows
        netd[:rowids] = _resize_or_nothing(lep.rowids, EMPTY_SPOT, nrows)
        netd[:b] = _resize_or_nothing(lep.b, 0.0, nrows)
    end
    
    # col stuf
    if ncols0 != ncols
        netd[:colids] = _resize_or_nothing(lep.colids, EMPTY_SPOT, ncols)
        netd[:c] = _resize_or_nothing(lep.c, 0.0, ncols)
        netd[:lb] = _resize_or_nothing(lep.lb, 0.0, ncols)
        netd[:ub] = _resize_or_nothing(lep.ub, 0.0, ncols)
    end
    
    # row x col stuf
    if nrows0 != nrows || ncols0 != ncols
        netd[:S] = _resize_or_nothing(lep.S, 0.0, nrows, ncols)
        netd[:C] = _resize_or_nothing(lep.C, 0.0, nrows, ncols)
    end
    
    netd[:extras] = lep.extras
    
    return  LEPModel(; netd...)
end

# LEP interface
resize(obj; kwargs...) = resize(lepmodel(obj); kwargs...) 