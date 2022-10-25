export extract_fields
function extract_fields(obj, fields = fieldnames(typeof(obj)))
    sdict = Dict{Symbol, Any}()
    for f in fields
        v = getfield(obj, f)
        sdict[f] = v
    end
    return sdict
end