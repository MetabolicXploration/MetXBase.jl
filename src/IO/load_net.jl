# addapted from `COBREXA.jl`
# TODO: make a pull request to COBREXA (DONE: waiting merge)
function _COBREXA_load_model(file_name::String, type)

    if type == ".json"
        net = COBREXA.load_json_model(file_name)
    elseif type == ".xml"
        net = COBREXA.load_sbml_model(file_name)
    elseif type == ".mat"
        net = COBREXA.load_mat_model(file_name)
    elseif type == ".h5"
        net = COBREXA.load_h5_model(file_name)
    else
        throw(DomainError(type, "Unknown file extension"))
    end

    return convert(COBREXA.StandardModel, net)
end

export load_net
function load_net(
        mfile::AbstractString;
        ext = last(splitext(mfile))
    )

    if ext == ".jls"
        net = deserializa(mfile)
    else
        net = _COBREXA_load_model(mfile, ext)
    end
    
    return convert(MetNet, net)
end