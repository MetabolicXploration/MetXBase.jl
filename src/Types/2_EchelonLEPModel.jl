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

    function EchelonLEPModel(lep::LEPModel{MT, VT}, G::MT, idxi::Vector{Int}, idxd::Vector{Int}, idxmap_inv::Vector{Int}, extras::Dict = Dict()) where {MT, VT}
        # Consistency checks between lep and G
        M, N = size(lep.S)
        Nd, Ni = size(G)
        
        # Check dimensions
        @assert Nd + Ni == N "Dimension mismatch: Nd ($Nd) + Ni ($Ni) ≠ N ($N)"
        @assert length(idxi) == Ni "Length of idxi ($(length(idxi))) ≠ Ni ($Ni)"
        @assert length(idxd) == Nd "Length of idxd ($(length(idxd))) ≠ Nd ($Nd)"
        @assert length(idxmap_inv) == N "Length of idxmap_inv ($(length(idxmap_inv))) ≠ N ($N)"
        
        # Check that idxi and idxd are valid indices
        @assert all(1 .<= idxi .<= N) "Invalid indices in idxi"
        @assert all(1 .<= idxd .<= N) "Invalid indices in idxd"
        @assert isempty(intersect(idxi, idxd)) "idxi and idxd must be disjoint"
        
        new{MT, VT}(lep, G, idxi, idxd, idxmap_inv, extras)
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