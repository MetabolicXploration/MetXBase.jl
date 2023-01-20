export TagDB
struct TagDB
    dat::Vector{Dict}

    TagDB() = new(Vector{Dict}[])
end

function TagDB(dat::Vector{<:Dict})
    db = TagDB()
    for el in dat
        push!(db, el)
    end
    return db
end

# ------------------------------------------------------------------
import Base.show
show(io::IO, db::TagDB) = println(io, "TagDB with ", length(db.dat), " objects")

# ------------------------------------------------------------------
function _tags_product(tags...)
    tags = collect(Any, tags)
    
    # handle types
    for (i, t) in enumerate(tags)
        # Char -> Vector{String}
        (t isa AbstractChar) && (tags[i] = [string(t)]; continue)
        # String -> Vector{String}
        (t isa AbstractString) && (tags[i] = [string(t)]; continue)
        # Function -> Vector{String}
        (t isa Function) && (tags[i] = [t]; continue)
        # # Tuple -> Vector{String}
        # (t isa Tuple) && (tags[i] = [t]; continue)
        # Regex -> Vector{String}
        (t isa Regex) && (tags[i] = [t]; continue)
    end
    
    return Iterators.product(tags...)
end

function _contains(f, col)
    for el in col
        f(el) && return true
    end
    return false
end

# To make isequal('A', "A") = true, this allows to use 'A':'B'
_isequal(x, y) = isequal(x, y)
_isequal(x::Integer, y::AbstractFloat) = false
_isequal(x::AbstractFloat, y::Integer) = false
_isequal(x::AbstractChar, y::AbstractString) = isequal(string(x), y)
_isequal(x::AbstractString, y::AbstractChar) = isequal(string(y), x)
_isequal(x) = Base.Fix2(_isequal, x)

_tags_match(tags::Vector, n::Number) = _contains(_isequal(n), tags)
_tags_match(tags::Vector, s::Char) = _contains(_isequal(s), tags)
_tags_match(tags::Vector, s::String) = _contains(_isequal(s), tags)
_tags_match(tags::Vector, f::Function) = _contains(f, tags)
_tags_match(tags::Vector, r::Regex) = _contains(tags) do t
    (t isa AbstractString) && !isnothing(match(r, t))
end
function _tags_match(tags::Vector, qs::Tuple)
    for q in qs
        _tags_match(tags, q) || return false
    end
    return true
end

# ------------------------------------------------------------------
# api

# ------------------------------------------------------------------
export doquery
function doquery(f::Function, db::TagDB, key, qs...)

    # The iteration order ensure the control from the query
    # of the searching sequence
    # Eg: doquery(f, db, "A", 1:3) will search the query ("A", (,1)) first
    for qs in _tags_product(qs...)
        found = false
        for obj in db.dat
            haskey(obj, "key") || continue
            isequal(key, obj["key"]) || continue
            haskey(obj, "tags") || continue
            _tags_match(obj["tags"], qs) || continue
            f(obj) === true && return nothing
            found = true
        end
        found || error("Obj not found, qs: ", qs)
    end

    return nothing
end

# ------------------------------------------------------------------
export query

function _query(db::TagDB, extract::Function, key, qs...)
    
    founds = []
    doquery(db, key, qs...) do obj
        push!(founds, extract(obj))
    end

    return founds
end
_query(db::TagDB, extract::String, key, qs...) = _query(db, keyval(extract), key, qs...)

query(db::TagDB, key, qs...; extract = identity) = _query(db, extract, key, qs...)
query(T::DataType, db::TagDB, key, qs...; kwargs...) = 
    convert(Vector{T}, query(db, key, qs...; kwargs...))

# ------------------------------------------------------------------
# ------------------------------------------------------------------
export queryfirst
function _queryfirst(db::TagDB, extract::Function, key, qs...)
    
    found = nothing
    doquery(db, key, qs...) do obj
        found = extract(obj)
        return true
    end

    return found
end
_queryfirst(db::TagDB, extract::String, key, qs...) = 
    _queryfirst(db, keyval(extract), key, qs...)

queryfirst(db::TagDB, key, qs...; extract = identity) = 
    _queryfirst(db, extract, key, qs...)

# ------------------------------------------------------------------
function _format_obj!(obj::Dict)
    if haskey(obj, "key")
        isa(obj["key"], String) || 
            error("unsupported 'key' type, got '$(typeof(obj["key"]))', expected 'String'. obj: $(obj)")
        else; error("'key' missing, obj: $(obj)")
    end
    if haskey(obj, "tags")
        isa(obj["tags"], Vector) || 
            error("unsupported 'tags' type, got '$(typeof(obj["tags"]))', expected 'Vector'. obj: $(obj)")
        else; obj["tags"] = Any[]
    end
end

# ------------------------------------------------------------------
import Base.push!
function Base.push!(db::TagDB, obj::Dict)
    _format_obj!(obj)
    push!(db.dat, obj)
end

function Base.push!(db::TagDB, key::String, tags::Vector;
        kwargs...
    )

    obj = Dict()

    # Add data
    for (k, v) in kwargs
        obj[string(k)] = v
    end

    # Add struct
    obj["key"] = string(key)
    obj["tags"] = tags

    push!(db, obj)

    return obj

end

push!(db::TagDB, key::String, tag, tags...; kwargs...) = 
    push!(db, key, Any[tag; tags...]; kwargs...)

push!(db::TagDB, key::String; kwargs...) = 
    push!(db, key, Any[]; kwargs...)

function push!(db::TagDB, p::Pair{String, <:Dict}) 
    obj = Dict(last(p))
    obj["key"] = string(first(p))
    push!(db, obj)
end


push!(dest::TagDB, src::TagDB) = push!(dest.dat, src.dat...)

# ------------------------------------------------------------------
export keyval
keyval(o, k) = getindex(o, k)
keyval(k) = Base.Fix2(getindex, k)