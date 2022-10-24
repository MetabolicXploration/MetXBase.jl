# TODO: rethink this
# # MetState
# # Interface
# av(s::AbstractMetState) = error("You must implement a 'av(s::$(typeof(s)))' method")
# va(s::AbstractMetState) = error("You must implement a 'va(s::$(typeof(s)))' method")

# av(s::Vector{<:Real}) = s
# va(s::Vector{<:Real}) = s

# # Commons getter interface
# for fun_name in [:av, :va]

#     @eval begin
#         $(fun_name)(state::AbstractMetState, idxs) = 
#             $(fun_name)(state)[idxs]
#         $(fun_name)(net::MetNet, state::AbstractMetState, ider) = 
#             $(fun_name)(state)[rxnindex(net, ider)]    
#         $(fun_name)(net::MetNet, state::AbstractMetState, iders::Vector) = 
#             [$(fun_name)(net, state, ider) for ider in iders]
#         $(fun_name)(net::MetNet, states::Vector, ider) =
#             [$(fun_name)(net, state, ider) for state in states]
#         $(fun_name)(nets::Vector, states::Vector, ider) = 
#             [$(fun_name)(net, state, ider) for (net, state) in zip(nets, states)]
#     end
# end