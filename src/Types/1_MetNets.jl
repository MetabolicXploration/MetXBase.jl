# The basic representation of a metabolic network
struct MetNet{MT, VT} <: AbstractMetNet
    
    # Constraints data
    S::Union{Nothing, MT}                                          # Stoichiometric matrix M x N sparse
    b::Union{Nothing, VT}                                          # right hand side of equation  S ν = b 
    c::Union{Nothing, VT}                                          # reaction index of biomass 
    lb::Union{Nothing, VT}                                         # fluxes lower bound M elements vector
    ub::Union{Nothing, VT}                                         # fluxes upper bound M elements vector 
    
    # Meta
    mets::Union{Nothing, Array{String,1}}                          # metabolites short-name M elements 
    rxns::Union{Nothing, Array{String,1}}                          # reactions short-name N elements
    
    # Relax types (avoid reading issues)
    genes # ::Union{Nothing, Array{String,1}}                      # gene names 
    rxnGeneMat # ::Union{Nothing, SparseMatrixCSC{Float64,Int}}    # 
    grRules # ::Union{Nothing, Array{String,1}}                    # gene-reaction rule N elements vector of strings (and / or allowed)
    metNames # ::Union{Nothing, Array{String,1}}                   # metabolites long-names M elements
    metFormulas # ::Union{Nothing, Array{String,1}}                # metabolites formula M elements
    rxnNames # ::Union{Nothing, Array{String,1}}                   # reactions long-names N elements
    subSystems # ::Union{Nothing, Array{String,1}}                 # cellular component of fluxes N elements

    # Extras
    extras::Dict{Any, Any}                                         # to store temp data

    function MetNet(
            S, b, c, lb, ub, mets, rxns, 
            genes, rxnGeneMat, grRules, metNames, 
            metFormulas, rxnNames, subSystems, 
            extras
        ) 
            MT = typeof(S)
            VT = something(b, c, lb, ub, Some(nothing)) |> typeof

            # TODO: do some consistency checking here (types, dims, ect...)

            return new{MT, VT}(
                S, b, c, lb, ub, mets, rxns, 
                genes, rxnGeneMat, grRules, metNames, 
                metFormulas, rxnNames, subSystems, 
                extras
            )
    end 

end

# Empty type
function MetNet(;
        S = nothing,
        b = nothing,
        c = nothing,
        lb = nothing,
        ub = nothing,
        
        mets = nothing,
        rxns = nothing,

        genes = nothing,
        rxnGeneMat = nothing,
        grRules = nothing,
        metNames = nothing,
        metFormulas = nothing,
        rxnNames = nothing,
        subSystems = nothing,
        
        extras = Dict{Any, Any}()
    ) 
    return MetNet(
        S, b, c, lb, ub, mets, rxns, 
        genes, rxnGeneMat, grRules, metNames, 
        metFormulas, rxnNames, subSystems, 
        extras
    )
end

"""
    Create a new MetNet from a template but overwriting the fields
    of the template with the given as kwargs.
    The returned MetNet will share the non-overwritten fields.
"""
function MetNet(template::MetNet; to_overwrite...)
    new_metnet_dict = Dict{Symbol, Any}(to_overwrite)

    for field in fieldnames(typeof(template))
        haskey(new_metnet_dict, field) && continue # avoid use the template version
        new_metnet_dict[field] = getfield(template, field)
    end
    
    return MetNet(;new_metnet_dict...)
end

