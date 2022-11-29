basis_rxns(net::MetNet; kwargs...) = basis_rxns(net.S, net.b; kwargs...)

function echelonize(net::MetNet; tol = 1e-10)

    _, _, idxmap, G, be = echelonize(net.S, net.b; tol)
    idxmap_inv = sortperm(idxmap)
    Nd, _ = size(G)
    IG = hcat(Matrix(I, Nd, Nd), G)[:, idxmap_inv]
    # spy(S)

    MT = typeof(net.S)
    VT = typeof(net.b)
    
    net1 = MetNet(;
        S = convert(MT, IG),
        b = convert(VT, be),
        rxns = _getindex_or_nothing(net.rxns, Colon()),
        lb = _getindex_or_nothing(net.lb, Colon()),
        ub = _getindex_or_nothing(net.ub, Colon()),
        c = _getindex_or_nothing(net.c, Colon()),
        extras = copy(net.extras),
        mets = ["M$i" for i in 1:Nd] # mets lost meaning
    )

    return net1
end
