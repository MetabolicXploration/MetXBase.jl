## ------------------------------------------------------------------
struct EchelonLEPModel{MT, VT} <: AbstractLEPModel

    lep::LEPModel{MT, VT} # The new ech network
    
    # echelonize
    G::MT
    idxi::Vector{Int} # index of the independent variables
    idxd::Vector{Int} # index of the independent variables
    idxmap_inv::Vector{Int} 

    # extras
    extras::Dict

    function EchelonLEPModel(lep::LEPModel{MT, VT}, G::MT, idxi::Vector{Int}, idxd::Vector{Int}, idxmap_inv::Vector{Int}) where {MT, VT}
        # TODO: Add consistency checks (between lep and G, ...)
        new{MT, VT}(lep, G, idxi, idxd, idxmap_inv)
    end

    function EchelonLEPModel(lep::LEPModel{MT, VT}; tol = 1e-10, verbose = false) where {MT, VT}

        # cache lep
        idxi, idxd, idxmap, G, be = echelonize(lep; tol, verbose)
        idxmap_inv = sortperm(idxmap)
        Nd, _ = size(G)
        IG = hcat(Matrix(I, Nd, Nd), G)[:, idxmap_inv]

        lep1 = LEPModel(lep;
            S = convert(MT, IG),
            b = convert(VT, be),
            rowids = String["M$i" for i in 1:Nd] # rows lost initial meaning
        )

        G = convert(MT, G)
        return new{MT, VT}(lep1, G, idxi, idxd, idxmap_inv, Dict())
    end
    
    # EchelonLEPModel() = new{Nothing, Nothing}(LEPModel(), Float64[;;], Int[], Int[], Int[], Dict())
end