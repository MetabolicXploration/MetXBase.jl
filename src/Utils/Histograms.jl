
## ------------------------------------------------------------
struct Histogram{elT}
    dim_spaces::Tuple
    count_dict::Dict{elT, Int}
    extras::Dict{Symbol, Any}
    function Histogram(s1, ss...)
        elT = Tuple{eltype.(tuple(s1, ss...))...}
        ss = tuple(s1, ss...)
        new{elT}(ss, Dict(), Dict())
    end
end

# ------------------------------------------------------------
import Base.haskey
Base.haskey(h::Histogram, v) = haskey(h.count_dict, v)
import Base.getindex
Base.getindex(h::Histogram, v) = getindex(h.count_dict, v)
import Base.keys
Base.keys(h::Histogram) = keys(h.count_dict)
Base.keys(h::Histogram, d::Integer) = (v[d] for v in keys(h.count_dict))
import Base.values
Base.values(h::Histogram) = (w::Int for w in values(h.count_dict))

# Merge histograms
import Base.merge!
function Base.merge!(h0::Histogram, h1::Histogram, hs::Histogram...)
    count_dict0::Dict{T, Int} = h0.count_dict
    for (x, c) in h1.count_dict
        get!(count_dict0, x, 0)
        count_dict0[x] += c
    end
    for hi in hs
        for (x, c) in hi.count_dict
            get!(count_dict0, x, 0)
            count_dict0[x] += c
        end
    end
    return h0
end

# ------------------------------------------------------------
# maps from Space -> bin
# eltype(Space) must return v's type
descretize(::Type{T}, v::T) where {T<:Number} = T(n)
descretize(S::AbstractRange, v) = getindex(S, _find_nearest(v, S))
descretize(F::Function, v) = F(v) # custom mapping
descretize(::T, n::T) where T = n # identity


# ------------------------------------------------------------
import Base.count!
function count!(h::Histogram, v)
    v = tuple((descretize(S, vi) for (S, vi) in zip(h.dim_spaces, v))...)
    get!(h.count_dict, v, 0)
    h.count_dict[v] += 1
    return h
end


# ## ------------------------------------------------------------
# struct Histogram{T}
#     bin_rule::Function
#     count_dict::Dict{T, Int}
#     extras::Dict{Symbol, Any}
#     function Histogram{T}(bin_rule::Function) where T
#         new{T}(bin_rule, Dict{T, Int}(), Dict{Symbol, Any}())
#     end
# end

# ## ------------------------------------------------------------
# # DONE: Use an interface similar to rand... rand(Space)...
# # rand(Bool) from booleas, rand([1, 2...]) from the given values, etc...
# # Histogram is just a collection of 'spaces' from which we can 'map' a value...
# # A custom space is just a function input -> bin (kind of the current status)...
# # but, for support multiple dimentions we should 

# ## ------------------------------------------------------------
# # Base
# import Base.getproperty
# function getproperty(h::Histogram, k::Symbol)
#     hasfield(typeof(h), k) && return getfield(h, k)
#     haskey(h.extras, k) && return getindex(h.extras, k)
#     getfield(h, k)
# end

# import Base.propertynames
# function propertynames(h::Histogram, ::Bool)
#     _ps = fieldnames(Histogram) |> collect
#     push!(_ps, keys(h.extras)...)
#     return _ps
# end

# import Base.hasproperty
# function hasproperty(h::Histogram, k::Symbol)
#     hasfield(typeof(h), k) || haskey(h.extras, k)
# end

# import Base.haskey
# haskey(h::Histogram, k::Symbol) = haskey(h.extras, k)

# import Base.getindex
# getindex(h::Histogram, k::Symbol) = getindex(h.extras, k)

# import Base.setindex!
# setindex!(h::Histogram, x, k::Symbol) = setindex!(h.extras, x, k)

# import Base.keys
# keys(h::Histogram) = keys(h.count_dict)
# import Base.values
# values(h::Histogram) = values(h.count_dict)

# # ------------------------------------------------------------
# function find_bin(h::Histogram{T}, v) where T
#     x::T = h.bin_rule(h, v) # apply bin_rule
#     isa(x, T) || error("Invalid bin_rule return type, expected: ", T, ", got: ", typeof(x))
#     return x
# end

# bins(h::Histogram) = keys(h)
# counts(h::Histogram) = values(h)
# counts(h::Histogram{T}, k::T) where T = h.count_dict[k]
# counts(h::Histogram{T}, ks::AbstractArray{T}) where T = [counts(h, k) for k in ks]
# counts(h::Histogram{T}, ks::Base.KeySet{T}) where T = [counts(h, k) for k in ks]

# import Base.count!
# function count!(h::Histogram{T}, v) where T
#     x::T = find_bin(h, v)
#     count_dict::Dict{T, Int} = h.count_dict
#     get!(count_dict, x, 0)
#     count_dict[x] += 1
#     return h
# end

# # Merge histograms
# function count!(h0::Histogram{T}, h1::Histogram{T}, hs::Histogram{T}...) where T
#     count_dict0::Dict{T, Int} = h0.count_dict
#     for (x, c) in h1.count_dict
#         get!(count_dict0, x, 0)
#         count_dict0[x] += c
#     end
#     for hi in hs
#         for (x, c) in hi.count_dict
#             get!(count_dict0, x, 0)
#             count_dict0[x] += c
#         end
#     end
#     return h0
# end


# ## ------------------------------------------------------------
# # Constructors

# # range_histogram
# function range_histogram(r::rT) where {rT <: AbstractRange}
#     vT = eltype(r)
#     # create histogram
#     h = Histogram{vT}() do _h, v
#         _bins::rT = _h.range
#         ci = _find_nearest(v, r)
#         return _bins[ci]
#     end
#     # add extras
#     h[:range] = r

#     return h
# end

# function range_histogram(x0, x1; kwargs...)
#     r = range(x0, x1; kwargs...)
#     return range_histogram(r)
# end

# function range_histogram(r1::AbstractRange, rs::AbstractRange...)
#     # create histogram
#     rs = tuple(r1, rs...)
#     vT = tuple(first.(rs)...) |> typeof
#     h = Histogram{vT}() do _h, v
#         I = Tuple(_find_nearest.(v, rs))
#         return getindex.(rs, I)
#     end
#     # add extras
#     return h
# end

# # identity_histogram
# __identity(::Histogram{T}, v::T) where T = v
# identity_histogram(vT::DataType) =  Histogram{vT}(__identity)
