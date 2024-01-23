# Must methods here only `delete` an ider by just overwriting it with 'EMPTY_SPOT'.
# Additionally they modify the stoi matrix
# Then we can create a new lep without them (emptyless_model)
# WARNING: The intermediate state is inconsistent

const EMPTY_SPOT = ""
findfirst_empty_spot(lep, ids_getter::Function) = 
    findfirst(isequal(EMPTY_SPOT), ids_getter(lep))

function findindex_or_empty_spot(model, getter, ider)
    indx = _hasid(model, getter, ider) ?
        _getindex(model, getter, ider) :
        findfirst_empty_spot(model, getter)
    isnothing(indx) && error("Non empty spot available, ider: ($ider), getter: $(nameof(getter))") 
    return indx 
end
    

findfirst_empty_row(lep) = findfirst_empty_spot(lep, rowids)
function _empty_row!(lep, row)
    rowi = rowindex(lep, row)
    _setindex!(lep.rowids, rowi, EMPTY_SPOT)
    _setindex!(lep.S, rowi, :, zero(eltype(lep.S)))
    return lep
end
empty_row!(lep, row) = (_empty_row!(lep, row); empty_void_iders!(lep))
has_empty_row(lep) = isnothing(findfirst_empty_row(lep))

findfirst_empty_col(lep) = findfirst_empty_spot(lep, colids)
function _empty_col!(lep, col)

    coli = colindex(lep, col)
    _setindex!(lep.colids, coli, EMPTY_SPOT)
    _setindex!(lep.S, :, coli, zero(eltype(lep.S)))
    
    return lep
end
empty_col!(lep, col) = (_empty_col!(lep, col); empty_void_iders!(lep))
has_empty_col(lep) = isnothing(findfirst_empty_col(lep))

# soft del iders with not impact on the network (e.g. contraints with all coes zero)
function empty_void_iders!(lep; 
        iters = 500 # to be sure
    )

    c0 = 0
    for it in 1:iters
        
        # find colids with no rowids
        void_cols = findall(all.(iszero, eachcol(lep.S)))
        !isempty(void_cols) && _empty_col!(lep, void_cols)

        # find rowids with no colids
        void_rows = findall(all.(iszero, eachrow(lep.S)))
        !isempty(void_rows) && _empty_row!(lep, void_rows)

        # check if changed
        c = length(void_rows) + length(void_cols)
        c == c0 && break
        c0 = c

    end

    return lep
end

# TODO: Test all this
# return a model without EMPTY_SPOT iders
function emptyless_model(lep)
    
    _rowids, _colids = Colon(), Colon()
    
    if !isnothing(rowids(lep))
        _rowids = findall(rowids(lep) .!= EMPTY_SPOT)
    end
    
    if !isnothing(colids(lep))
        _colids = findall(colids(lep) .!= EMPTY_SPOT)
    end

    return reindex(lep, _rowids, _colids)
end
