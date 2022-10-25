## ------------------------------------------------------------------
# COBREXA
import Base.convert
function convert(::Type{MetNet}, cobxa_model::COBREXA.MetabolicModel)
    net = Dict()
    net[:S] = COBREXA.stoichiometry(cobxa_model)
    net[:b] = COBREXA.balance(cobxa_model)
    net[:lb], net[:ub] = COBREXA.bounds(cobxa_model)
    net[:c] = COBREXA.objective(cobxa_model)
    net[:rxns] = COBREXA.reactions(cobxa_model)
    net[:mets] = COBREXA.metabolites(cobxa_model)

    net[:metNames] = COBREXA.metabolite_name.([cobxa_model], COBREXA.metabolites(cobxa_model))
    net[:rxnNames] = COBREXA.reaction_name.([cobxa_model], COBREXA.reactions(cobxa_model))
    net[:metFormulas] = COBREXA.metabolite_formula.([cobxa_model], COBREXA.metabolites(cobxa_model))
    net[:genes] = COBREXA.genes(cobxa_model)
    # net[:grRules] = COBREXA.reaction_gene_association.([cobxa_model], COBREXA.reactions(cobxa_model))
    net[:subSystems] = COBREXA.reaction_subsystem.([cobxa_model], COBREXA.reactions(cobxa_model))

    return MetNet(;net...)
end

convert(::Type{COBREXA.CoreModel}, net::MetNet) = COBREXA.CoreModel(
    isnothing(net.S) ? Float64[;;] : net.S,
    isnothing(net.b) ? Float64[] : net.b,
    isnothing(net.c) ? Float64[] : net.c,
    isnothing(net.lb) ? Float64[] : net.lb,
    isnothing(net.ub) ? Float64[] : net.ub,
    isnothing(net.rxns) ? String[] : net.rxns,
    isnothing(net.mets) ? String[] : net.mets,
)
