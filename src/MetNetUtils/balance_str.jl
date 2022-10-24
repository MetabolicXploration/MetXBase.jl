# function balance_str(model::MetNet, ider; digits = 50)
#     meti = metindex(model, ider)
#     rxns = model.rxns[met_rxns(model, ider)] |> sort
#     b_str = []
#     for rxn in rxns
#         s = round(S(model, meti, rxn), digits = digits)
#         push!(b_str, "($s)$rxn")
#     end
#     return "$(model.mets[meti]): " * join(b_str, " + ") * " == " * 
#                 "$(round(model.b[meti], digits = digits))"
# end

# function balance_str(model::MetNet, state::AbstractMetState, ider; digits = 50)
#     meti = metindex(model, ider)
#     rxns = model.rxns[met_rxns(model, ider)] |> sort
#     b_str = []
#     b = 0.0
#     for rxn in rxns
#         s = round(S(model, meti, rxn), digits = digits)
#         f = round(av(model, state, rxn), digits = digits)
#         sf = round(s*f, digits = digits)
#         b += s*f
#         push!(b_str, "($s*$f=$sf)$(rxn)")
#     end
#     return "$(model.mets[meti]): " * join(b_str, " + ") * " [tot: $(round(b, digits = digits))]" * " == " * 
#                 "$(round(model.b[meti], digits = digits))"
# end
# balance_str(model, state::AbstractMetState, iders::Vector; digits = 50) = 
#     [balance_str(model, state, ider; digits = digits) for ider in iders]