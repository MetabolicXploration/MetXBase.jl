# Must methods here only `delete` an ider by just overwriting it with 'EMPTY_SPOT' and modifiying S with 0.
# Additionally they modify the stoi matrix
# Then we can create a new lep without them (emptyless_model)
# WARNING: The intermediate state is inconsistent

const EMPTY_SPOT = ""

function _empty_row!(lep::LEPModel, row)
    rowi = rowindex(lep, row)
    _setindex!(lep.rowids, rowi, EMPTY_SPOT)
    _setindex!(lep.S, rowi, :, zero(eltype(lep.S)))
    return lep
end
empty_row!(lep::LEPModel, row) = (_empty_row!(lep, row); empty_void_iders!(lep))

function _empty_col!(lep::LEPModel, col)

    coli = colindex(lep, col)
    _setindex!(lep.colids, coli, EMPTY_SPOT)
    _setindex!(lep.S, :, coli, zero(eltype(lep.S)))
    
    return lep
end
empty_col!(lep::LEPModel, col) = (_empty_col!(lep, col); empty_void_iders!(lep))

# soft del iders with not impact on the network (e.g. contraints with all coes zero)
function empty_void_iders!(lep::LEPModel; 
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
function emptyless_model(lep::LEPModel)
    
    rowids, colids = Colon(), Colon()
    
    if !isnothing(lep.rowids)
        rowids = findall(lep.rowids .!= EMPTY_SPOT)
    end
    
    if !isnothing(lep.colids)
        colids = findall(lep.colids .!= EMPTY_SPOT)
    end

    return reindex(lep, rowids, colids)
end
