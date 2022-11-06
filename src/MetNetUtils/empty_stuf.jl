# Must methods here only `delete` an ider by just overwriting it with 'EMPTY_SPOT' and modifiying S with 0.
# Additionally they modify the stoi matrix
# Then we can create a new net without them (emptyless_model)
# WARNING: The intermediate state is inconsistent

const EMPTY_SPOT = ""

export empty_met!
function _empty_met!(net::MetNet, met)
    
    meti = metindex(net, met)
    _setindex!(net.mets, meti, EMPTY_SPOT)
    _setindex!(net.S, meti, :, zero(eltype(net.S)))
    return net
end
empty_met!(net::MetNet, met) = (_empty_met!(net, met); empty_void_iders!(net))

export empty_rxn!
function _empty_rxn!(net::MetNet, rxn)

    rxni = rxnindex(net, rxn)
    _setindex!(net.rxns, rxni, EMPTY_SPOT)
    _setindex!(net.S, :, rxni, zero(eltype(net.S)))
    
    return net
end
empty_rxn!(net::MetNet, rxn) = (_empty_rxn!(net, rxn); empty_void_iders!(net))

# soft del iders with not impact of the network (e.g. mets without reactions)
export empty_void_iders!
function empty_void_iders!(net::MetNet; 
        iters = 500 # to be sure
    )

    c0 = 0
    for it in 1:iters
        
        # find rxns with no mets
        void_rxns = findall(all.(iszero, eachcol(net.S)))
        !isempty(void_rxns) && _empty_rxn!(net, void_rxns)

        # find mets with no rxns
        void_mets = findall(all.(iszero, eachrow(net.S)))
        !isempty(void_mets) && _empty_met!(net, void_mets)

        # check if changed
        c = length(void_mets) + length(void_rxns)
        c == c0 && break
        c0 = c

    end

    return net
end

# TODO: Test all this
# return a model without EMPTY_SPOT iders
export emptyless_model
function emptyless_model(net::MetNet)
    
    met_idxs, rxn_idxs, genes_idxs = Colon(), Colon(), Colon()
    
    if !isnothing(net.mets)
        met_idxs = findall(net.mets .!= EMPTY_SPOT)
    end
    
    if !isnothing(net.rxns)
        rxn_idxs = findall(net.rxns .!= EMPTY_SPOT)
    end
    
    if !isnothing(net.genes)
        genes_idxs = findall(net.genes .!= EMPTY_SPOT)
    end

    return del_iders(net::MetNet;
        met_idxs, rxn_idxs, genes_idxs,
    )
end
