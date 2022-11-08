# ## ------------------------------------------------------------------
# struct EchelonMetNet{MT, VT} <: AbstractMetNet

#     IG::MT                                      # net.S in echelon forms 
#     ech_b::VT                                   # net.b after the reduction
    
#     rxns::Vector{String}

#     # mapping
#     idxind::Vector{Int}
#     idxdep::Vector{Int}
#     idxmap::Vector{Int}                         # mapping from EchelonMetNet to the src MetNet reactions

#     # src
#     net::MetNet{MT, VT}                         # A reference to the original (use for metadata)

#     function EchelonMetNet(net::MetNet; 
#             eps = 1e-10
#         )

#         # cache net    
#         idxind, idxdep, idxmap, IG, ech_b = echelonize(net.S, net.b; eps)
        
#         MT = matrix_type(net)
#         VT = vector_type(net)

#         IG = convert(MT, IG)
#         return new{MT, VT}(IG, ech_b)

#     end

# end