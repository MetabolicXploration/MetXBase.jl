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

# Reduce the stoi matrix by del the fixxed mets
export empty_fixxed!
function empty_fixxed!(net::MetNet; eps = 0.0, protect = [])

    protect = rxnindex(net, protect)

    M, N = size(net)

    non_protected = trues(N)
    non_protected[protect] .= false

    # up bounds
    fixxed = falses(N)
    for ri in findall(non_protected)
        if net.lb[ri] == net.ub[ri] # fixxed
            fixxed[ri] = iszero(eps)
            net.ub[ri], net.lb[ri] = (net.lb[ri] - eps), (net.ub[ri] + eps)
        end
    end
    
    # balance
    net.b .= net.b - net.S * (fixxed .* net.lb)

    # del 
    empty_rxn!(net, findall(fixxed))

    return net
end

# TODO: Test all this
# return a model without EMPTY_SPOT iders
export emptyless_model
function emptyless_model(net::MetNet)

    # TODO: find this rxnGeneMat goes

    netd = Dict()
    met_idxs, rxn_idxs, genes_idxs = nothing, nothing, nothing
    
    if !isnothing(net.mets)
        met_idxs = findall(net.mets .!= EMPTY_SPOT)
        netd[:mets] = _index_or_nothing(net.mets, met_idxs)
        netd[:metNames] = _index_or_nothing(net.metNames, met_idxs)
        netd[:metFormulas] = _index_or_nothing(net.metFormulas, met_idxs)
        netd[:b] = _index_or_nothing(net.b, met_idxs)
    end
    
    if !isnothing(net.rxns)
        rxn_idxs = findall(net.rxns .!= EMPTY_SPOT)
        netd[:rxns] = _index_or_nothing(net.rxns, rxn_idxs)
        netd[:rxnNames] = _index_or_nothing(net.rxnNames, rxn_idxs)
        netd[:c] = _index_or_nothing(net.c, rxn_idxs)
        netd[:lb] = _index_or_nothing(net.lb, rxn_idxs)
        netd[:ub] = _index_or_nothing(net.ub, rxn_idxs)
        netd[:subSystems] = _index_or_nothing(net.rxnNames, rxn_idxs)
        netd[:grRules] = _index_or_nothing(net.grRules, rxn_idxs)
    end
    
    if !isnothing(net.genes)
        genes_idxs = findall(net.genes .!= EMPTY_SPOT)
        netd[:genes] = _index_or_nothing(net.genes, genes_idxs)
    end

    if !isnothing(net.rxns) && !isnothing(net.mets)
        netd[:S] = _index_or_nothing(net.S, met_idxs, rxn_idxs)
    end

    return MetNet(; netd...)
end

_index_or_nothing(v, i, is...) = (isnothing(v) || isempty(v)) ? v : v[i, is...]