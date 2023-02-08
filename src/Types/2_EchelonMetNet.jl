## ------------------------------------------------------------------
export EchelonMetNet
struct EchelonMetNet{MT, VT} <: AbstractMetNet

    net::MetNet{MT, VT} # The new ech network
    
    # echelonize
    G::Matrix{Float64} # TODO: Use types
    idxf::Vector{Int}
    idxd::Vector{Int}
    idxmap_inv::Vector{Int}

    # extras
    extras::Dict

    function EchelonMetNet(net::MetNet; tol = 1e-10)

        # cache net
        idxf, idxd, idxmap, G, be = echelonize(net.S, net.b; tol)
        idxmap_inv = sortperm(idxmap)
        Nd, _ = size(G)
        IG = hcat(Matrix(I, Nd, Nd), G)[:, idxmap_inv]
        
        MT = matrix_type(net)
        VT = vector_type(net)

        net1 = MetNet(;
            S = convert(MT, IG),
            b = convert(VT, be),
            rxns = _getindex_or_nothing(net.rxns, Colon()),
            lb = _getindex_or_nothing(net.lb, Colon()),
            ub = _getindex_or_nothing(net.ub, Colon()),
            c = _getindex_or_nothing(net.c, Colon()),
            extras = copy(net.extras),
            mets = String["M$i" for i in 1:Nd] # mets lost meaning
        )

        return new{MT, VT}(net1, G, idxf, idxd, idxmap_inv, Dict())
    end
    
    EchelonMetNet() = new{Nothing, Nothing}(MetNet(), Float64[;;], Int[], Int[], Int[], Dict())
end