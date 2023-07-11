
## ------------------------------------------------------------
function _filter_metxmat_write_noncompat_types!(dict)
    _keys = keys(dict)
    for k in _keys
        v = dict[k]
        # isconcretetype(v) && isa(v, Array) && continue
        isa(v, Number) && continue
        isa(v, String) && continue
        isa(v, Bool) && continue
        isa(v, AbstractArray{<:Number}) && continue
        isa(v, AbstractArray{<:AbstractString}) && continue
        isa(v, Dict) && _filter_metxmat_write_noncompat_types!(v) # recursive
        isa(v, Dict) && continue
        delete!(dict, k)
    end
    return dict
end


## ------------------------------------------------------------
function _recover_type(v::AbstractArray)
    if eltype(v) == Any
        T0 = typeof(first(v))
        for vi in v
            T = typeof(vi)
            T0 != T && error("Non homogeneus array")
        end
        return T0[vi for vi in v]
    end
    return v
end

# rectify loading type inference
function _format_metxmat_write_noncompat_types!(dict::Dict)
    _keys = keys(dict)
    for k in _keys
        v = dict[k]

        # base
        isa(v, AbstractChar) && (dict[k] = string(v); continue)
        isa(v, AbstractString) && (dict[k] = string(v); continue)
        
        # array
        isa(v, AbstractArray) && (v = _recover_type(v)) # keep going
        isa(v, AbstractArray{<:AbstractChar}) && (dict[k] = string.(v); continue)
        isa(v, AbstractArray{<:AbstractString}) && (dict[k] = string.(v); continue)
        
        # dict
        isa(v, Dict) && (_format_metxmat_write_noncompat_types!(v); continue) # recursive

    end
    return dict
end

## ------------------------------------------------------------
function load_metxmat(mfile)

    ext = last(splitext(mfile))
    ext == ".mat" || error("Only .mat files are supported")

    lep_dict = MAT.matread(mfile)
    haskey(lep_dict, "MetXMAT") || error("Uncompatoble model struct, 'MetXMAT' key expected.")
    lep_dict = lep_dict["MetXMAT"]
    return _format_metxmat_write_noncompat_types!(lep_dict)
end

# ------------------------------------------------------------
function save_metxmat!(mfile, dict::Dict; compress = true)

    ext = last(splitext(mfile))
    ext == ".mat" || error("Only .mat files are supported")

    _filter_metxmat_write_noncompat_types!(dict)

    MAT.matwrite(mfile, Dict("MetXMAT" => dict); compress)
end

