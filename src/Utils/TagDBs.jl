# ## ------------------------------------------------------------
# # Implement InvertedIndices.jl stuff

# # ------------------------------------------------------------------
# export TagDB
# struct TagDB
#     dat::Vector{Dict}
#     TagDB() = new(Vector{Dict}[])
# end

# function TagDB(dat::Vector{<:Dict})
#     db = TagDB()
#     for el in dat
#         push!(db, el)
#     end
#     return db
# end

# # ------------------------------------------------------------------
# import Base.show
# show(io::IO, db::TagDB) = println(io, "TagDB with ", length(db.dat), " objects")

# # ------------------------------------------------------------------
# # Char -> Vector{Char}
# _factor_format(x::AbstractChar) = Char[x]
# # String -> Vector{String}
# _factor_format(x::AbstractString) = String[string(x)]
# # Pair
# function _factor_format(p::Pair)
#     k, v = _factor_format(first(p)), _factor_format(last(p)) 
#     return Pair[k => v for (k, v) in Iterators.product(k, v)]
# end
# # Arrays are broadcateds
# _factor_format(x::AbstractArray) = x

# # callback
# _factor_format(x) = typeof(x)[x]

# function _tags_product(tags...)
#     tags = collect(Any, tags)
    
#     # handle types
#     for (i, t) in enumerate(tags)
#         tags[i] = _factor_format(t)
#     end
    
#     return Iterators.product(tags...)
# end

# _tagkey(x::Pair) = first(x)
# _tagkey(x::Any) = x

# _tagval(x::Pair) = last(x)
# _tagval(::Any) = nothing

# _ismatch(f::Function, y) = f(y) === true
# _ismatch(y, f::Function) = _ismatch(f, y)
# _ismatch(x::Integer, y::AbstractFloat) = false
# _ismatch(x::AbstractFloat, y::Integer) = false
# # To make _ismatch('A', "A") = true, this allows to use 'A':'B'
# _ismatch(x::AbstractChar, y::AbstractString) = isequal(string(x), y)
# _ismatch(x::AbstractString, y::AbstractChar) = isequal(string(y), x)
# _ismatch(r::Regex, y) = !isnothing(match(r, string(y)))
# _ismatch(y, r::Regex) = _ismatch(r, y)
# _ismatch(x::T, y::T) where T = isequal(x, y)
# _ismatch(x, y) = isequal(x, y)
# _ismatch(x) = Base.Fix1(_ismatch, x)

# # call _ismatch to an object
# # A non pair is assume to match only keys
# function _obj_match(obj::Dict, q::Any)
#     for k in keys(obj)
#         _ismatch(k, q) && return true
#     end
#     return false
# end

# # A pair must match both
# function _obj_match(obj::Dict, p::Pair)
#     kq, vq = p
#     for (k, v) in obj
#         _ismatch(k, kq) || continue
#         _ismatch(v, vq) && return true
#     end
#     return false
# end

# # A pair must match all elms
# function _obj_match(obj::Dict, qs::Tuple)
#     for qi in qs
#         _obj_match(obj, qi) || return false
#     end
#     return true
# end

# # ------------------------------------------------------------------
# # api

# # ------------------------------------------------------------------
# function _doquery(f::Function, db::TagDB, errflag::Bool, q, qs...)

#     # The iteration order ensure the control from the query
#     # of the searching sequence
#     # Eg: doquery(f, db, "A", 1:3) will search the query ("A", (,1)) first
#     for qs in _tags_product(q, qs...)
#         found = false
#         for obj in db.dat
#             _obj_match(obj, qs) || continue
#             f(obj) === true && return nothing
#             found = true
#         end
#         if errflag
#             found || error("Obj not found, q: ", q, ", qs: ", qs)
#         end
#     end

#     return nothing
# end

# export doquery
# function doquery(f::Function, db::TagDB, q, qs...; 
#         errflag = true
#     ) 
#     return _doquery(f, db, errflag, q, qs...)
# end

# # ------------------------------------------------------------------
# _sort!(obj::Vector, by::Function, rev::Bool) = sort!(obj; by, rev)
# _sort!(obj::Vector, ::Nothing, ::Bool) = obj # noop
# _sort!(obj::Vector, k, rev::Bool) = sort!(obj; by = keyval(k), rev)

# function _query(db::TagDB, errflag::Bool, extract::Function, q, qs...; 
#         sortby = nothing, 
#         rev = false
#     )
    
#     objs = Dict[]
#     _doquery(db, errflag, q, qs...) do obj
#         push!(objs, obj)
#     end

#     # sort
#     _sort!(objs, sortby, rev)

#     # extract
#     return map(extract, objs)
# end
# _query(db::TagDB, errflag::Bool, extract, q, qs...; kwargs...) = _query(db, errflag, keyval(extract), q, qs...; kwargs...)

# export query
# function query(db::TagDB, q, qs...; 
#         extract = identity, errflag = true, 
#         sortby = nothing, rev = false
#     )
#     return _query(db, errflag, extract, q, qs...; sortby, rev)
# end
# query(T::DataType, db::TagDB, q, qs...; kwargs...) = 
#     convert(Vector{T}, query(db, q, qs...; kwargs...))


# import Base.getindex
# Base.getindex(db::TagDB, q, qs...) = query(db::TagDB, q, qs...)

# import Base.get
# function Base.get(f::Function, db::TagDB, q, qs...)
#     objs = _query(db, false, identity, q, qs...; sortby = nothing)
#     isempty(objs) && return f()
#     return objs
# end

# import Base.get!
# function Base.get!(f::Function, db::TagDB, q, qs...)
#     objs = _query(db, false, identity, q, qs...; sortby = nothing)
#     if isempty(objs)
#         obj = _build_obj(q, qs...)
#         obj = f(obj)::Dict
#         push!(db, obj)
#         return Dict[obj]
#     end
#     return objs
# end

# # ------------------------------------------------------------------
# # ------------------------------------------------------------------
# function _queryfirst(db::TagDB, errflag::Bool, extract::Function, q, qs...)
    
#     found = nothing
#     _doquery(db, errflag, q, qs...) do obj
#         found = extract(obj)
#         return true
#     end

#     return found
# end
# _queryfirst(db::TagDB, errflag::Bool, extract, q, qs...) = 
#     _queryfirst(db, errflag, keyval(extract), q, qs...)

# export queryfirst
# function queryfirst(db::TagDB, q, qs...; 
#         extract = identity, 
#         errflag = true
#     )
#     _queryfirst(db, errflag, extract, q, qs...)
# end

# export getfirst!
# function getfirst!(f::Function, db::TagDB, q, qs...)
#     obj = _queryfirst(db, false, identity, q, qs...)
#     if isnothing(obj)
#         obj = _build_obj(q, qs...)
#         obj = f(obj)::Dict
#         push!(db, obj)
#         return obj
#     end
#     return obj
# end

# export setfirst!
# function setfirst!(f!::Function, db::TagDB, q, qs...)
#     obj = _queryfirst(db, false, identity, q, qs...)
#     if isnothing(obj)
#         obj = _build_obj(q, qs...)
#         push!(db, obj)
#     end
#     f!(obj)
#     return obj
# end

# # ------------------------------------------------------------------
# function _build_obj(tags...; kwrags...)
#     obj = Dict{Any, Any}(kwrags...)
#     for t in tags
#         if t isa Pair
#             obj[first(t)] = last(t)
#         else
#             obj[t] = nothing # placeholder
#         end
#     end
#     return obj
# end

# # ------------------------------------------------------------------
# import Base.push!
# Base.push!(db::TagDB, obj::Dict) = (push!(db.dat, obj); obj)
# Base.push!(db::TagDB, tags...; kwobj...) = push!(db, _build_obj(tags...; kwobj...))
# Base.push!(dest::TagDB, src::TagDB) = push!(dest.dat, src.dat...)



# # ------------------------------------------------------------------
# export keyval
# function keyval(obj::Dict, q)
#     for k in keys(obj)
#         _ismatch(k, q) && return getindex(obj, k)
#     end
#     return getindex(obj, q)
# end
# keyval(q) = Base.Fix2(keyval, q)
