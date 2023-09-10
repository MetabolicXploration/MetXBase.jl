function set_constraint!(lep, colid;
        S = nothing,
        lb = nothing,
        ub = nothing,
    )

    # col stuf
    col_idx = findindex_or_empty_spot(lep, colids, colid)
    _setindex_or_nothing!(lep.colids, col_idx, colid)
    _setindex_or_nothing!(lep.c, col_idx, 0.0)
    isnothing(lb) || _setindex_or_nothing!(lep.lb, col_idx, lb)
    isnothing(ub) || _setindex_or_nothing!(lep.ub, col_idx, ub)

    # row x col stuf
    isnothing(S) || for (rowid, s) in S
        row_idx = findindex_or_empty_spot(lep, rowids, rowid)
        _setindex_or_nothing!(lep.rowids, row_idx, rowid)
        _setindex_or_nothing!(lep.b, row_idx, 0.0)

        _setindex_or_nothing!(lep.S, row_idx, col_idx, s)
        _setindex_or_nothing!(lep.C, row_idx, col_idx, 0.0)
    end

    return lep
end