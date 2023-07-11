## ------------------------------------------------------------
function save_metxmat(lep::LEPModel, mfile; compress = true)
    
    # lep fields
    lep_dict = extract_fields(lep; keymap = string)
    
    save_metxmat!(mfile, lep_dict; compress)
end

# ------------------------------------------------------------
function load_metxmat(::Type{LEPModel}, mfile)
    
    # load
    lep_dict = load_metxmat(mfile)

    # lep
    return LEPModel(;
        Dict(Symbol(k) => v for (k, v) in lep_dict)...
    )
end
