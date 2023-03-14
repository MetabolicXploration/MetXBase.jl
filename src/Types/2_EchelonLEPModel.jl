## ------------------------------------------------------------------
struct EchelonLEPModel{MT, VT} <: AbstractLEPModel

    lep::LEPModel{MT, VT} # The new ech network
    
    # echelonize
    G::MT
    idxf::Vector{Int}
    idxd::Vector{Int}
    idxmap_inv::Vector{Int}

    # extras
    extras::Dict

    function EchelonLEPModel(lep::LEPModel; tol = 1e-10)

        # cache lep
        idxf, idxd, idxmap, G, be = echelonize(lep.S, lep.b; tol)
        idxmap_inv = sortperm(idxmap)
        Nd, _ = size(G)
        IG = hcat(Matrix(I, Nd, Nd), G)[:, idxmap_inv]
        
        MT = matrix_type(lep)
        VT = vector_type(lep)

        lep1 = LEPModel(;
            S = convert(MT, IG),
            b = convert(VT, be),
            rowids = String["M$i" for i in 1:Nd] # rows lost initial meaning
        )

        G = convert(MT, G)
        return new{MT, VT}(lep1, G, idxf, idxd, idxmap_inv, Dict())
    end
    
    # EchelonLEPModel() = new{Nothing, Nothing}(LEPModel(), Float64[;;], Int[], Int[], Int[], Dict())
end