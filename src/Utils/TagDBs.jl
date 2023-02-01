# ------------------------------------------------------------------
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
# Simbol -> Vector
_factor_format(x::Symbol) = Symbol[x]
# Char -> Vector{String}
_factor_format(x::AbstractChar) = String[string(x)]
# String -> Vector{String}
_factor_format(x::AbstractString) = String[string(x)]
# Function -> Vector{String}
_factor_format(x::Function) = Function[x]
# Regex -> Vector{Regex}
_factor_format(x::Regex) = Regex[x]
# Pair
function _factor_format(p::Pair)
    k, v = _factor_format(first(p)), _factor_format(last(p)) 
    return Pair[k => v for (k, v) in Iterators.product(k, v)]
end
# callback
_factor_format(x::Any) = x

function _tags_product(tags...)
    tags = collect(Any, tags)
    
    # handle types
    for (i, t) in enumerate(tags)
        tags[i] = _factor_format(t)
    end
    
    return Iterators.product(tags...)
end

_tagval(x::Pair) = last(x)
_tagval(x) = x

_tagkey(::Any) = nothing
_tagkey(x::Pair) = first(x)

function _contains(f, col, extract)
    for el in col
        f(extract(el)) && return true
    end
    return false
end

# To make _ismatch('A', "A") = true, this allows to use 'A':'B'
_ismatch(x, y) = isequal(x, y)
_ismatch(f::Function, y) = f(y) === true
_ismatch(x::Integer, y::AbstractFloat) = false
_ismatch(x::AbstractFloat, y::Integer) = false
_ismatch(x::AbstractChar, y::AbstractString) = isequal(string(x), y)
_ismatch(x::AbstractString, y::AbstractChar) = isequal(string(y), x)
_ismatch(x) = Base.Fix1(_ismatch, x)

_tags_match(tags::Vector, n::Number) = _contains(_ismatch(n), tags, _tagval)
_tags_match(tags::Vector, s::Char) = _contains(_ismatch(s), tags, _tagval)
_tags_match(tags::Vector, s::String) = _contains(_ismatch(s), tags, _tagval)
_tags_match(tags::Vector, f::Function) = _contains(f, tags, _tagval)
_tags_match(tags::Vector, r::Regex) = _contains(tags, _tagval) do v
    (v isa AbstractString) && !isnothing(match(r, v))
end
_tags_match(tags::Vector, p::Pair)  = _contains(tags, identity) do t
    _ismatch(first(p), _tagkey(t)) || return false
    _ismatch(last(p), _tagval(t)) || return false
    return true
end

function _tags_match(tags::Vector, qs::Tuple)
    for qi in qs
        _tags_match(tags, qi) || return false
    end
    return true
end

# ------------------------------------------------------------------
# api

# ------------------------------------------------------------------
function _doquery(f::Function, db::TagDB, errflag::Bool, q, qs...)

    # The iteration order ensure the control from the query
    # of the searching sequence
    # Eg: doquery(f, db, "A", 1:3) will search the query ("A", (,1)) first
    for qs in _tags_product(q, qs...)
        found = false
        for obj in db.dat
            haskey(obj, "tags") || continue
            _tags_match(obj["tags"], qs) || continue
            f(obj) === true && return nothing
            found = true
        end
        if errflag
            found || error("Obj not found, q: ", q, ", qs: ", qs)
        end
    end

    return nothing
end

export doquery
function doquery(f::Function, db::TagDB, q, qs...; 
        errflag = true
    ) 
    return _doquery(f, db, errflag, q, qs...)
end

# ------------------------------------------------------------------
function _query(db::TagDB, errflag::Bool, extract::Function, q, qs...)
    
    founds = []
    _doquery(db, errflag, q, qs...) do obj
        push!(founds, extract(obj))
    end

    return founds
end
_query(db::TagDB, errflag::Bool, extract::String, q, qs...) = _query(db, errflag, keyval(extract), q, qs...)

export query
function query(db::TagDB, q, qs...; 
        extract = identity, errflag = true
    )
    return _query(db, errflag, extract, q, qs...)
end
query(T::DataType, db::TagDB, q, qs...; kwargs...) = 
    convert(Vector{T}, query(db, q, qs...; kwargs...))


# ------------------------------------------------------------------
# ------------------------------------------------------------------
function _queryfirst(db::TagDB, errflag::Bool, extract::Function, q, qs...)
    
    found = nothing
    _doquery(db, errflag, q, qs...) do obj
        found = extract(obj)
        return true
    end

    return found
end
_queryfirst(db::TagDB, extract::String, q, qs...) = 
    _queryfirst(db, keyval(extract), q, qs...)

export queryfirst
function queryfirst(db::TagDB, q, qs...; 
        extract = identity, 
        errflag = true
    )
    
    _queryfirst(db, errflag, extract, q, qs...)
end

# ------------------------------------------------------------------
# DONE: check tag types
const _TAGS_LEGAL_TYPES = [AbstractChar, AbstractString, Symbol, Number, Pair]
function _format_obj!(obj::Dict)
    if haskey(obj, "tags")
        isa(obj["tags"], Vector) || 
            error("unsupported 'tags' type, got '$(typeof(obj["tags"]))', expected 'Vector'. obj: $(obj)")
        else; obj["tags"] = Any[]
    end

    for tag in obj["tags"]
        T = typeof(tag)

        ok = false
        for T0 in _TAGS_LEGAL_TYPES
            T <: T0 && (ok = true; break)
        end
        ok || error("ilegal tag type, got: ", T , ", expected: ", _TAGS_LEGAL_TYPES)
        
    end
end

# ------------------------------------------------------------------
import Base.push!
function Base.push!(db::TagDB, obj::Dict)
    _format_obj!(obj)
    push!(db.dat, obj)
end

function Base.push!(db::TagDB, tags::Vector; kwargs...)

    obj = Dict()

    # Add data
    for (k, v) in kwargs
        obj[string(k)] = v
    end

    # Add struct
    obj["tags"] = tags

    push!(db, obj)

    return obj

end

push!(db::TagDB, tag, tags...; kwargs...) = 
    push!(db, Any[tag; tags...]; kwargs...)

# function push!(db::TagDB, p::Pair{String, <:Dict}) 
#     obj = Dict(last(p))
#     obj["tags"] = Any[string(first(p))]
#     push!(db, obj)
# end


push!(dest::TagDB, src::TagDB) = push!(dest.dat, src.dat...)

# ------------------------------------------------------------------
export keyval
keyval(o, k) = getindex(o, k)
keyval(k) = Base.Fix2(getindex, k)