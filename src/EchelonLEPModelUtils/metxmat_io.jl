## ------------------------------------------------------------
function save_metxmat(elep::EchelonLEPModel, mfile; compress = true)

    # elep-only fields
    # [:G, :extras, :idxd, :idxi, :idxmap_inv]
    elep_dict = extract_fields(elep; keymap = string)
    # lep fields
    lep_dict = extract_fields(elep.lep; keymap = string)
    elep_dict["lep"] = lep_dict
    
    # save
    save_metxmat!(mfile, elep_dict; compress)
end


# ------------------------------------------------------------
function load_metxmat(::Type{EchelonLEPModel}, mfile)
    
    # load
    elep_dict = load_metxmat(mfile)

    # lep
    lep = LEPModel(;
        Dict(Symbol(k) => v for (k, v) in elep_dict["lep"])...
    )

    # elep
    return EchelonLEPModel(lep, 
        elep_dict["G"], elep_dict["idxi"], elep_dict["idxd"], elep_dict["idxmap_inv"]
    )
 
end
