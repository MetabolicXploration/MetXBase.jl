struct Histogram{T}
    bin_rule::Function
    count_dict::Dict{T, Int}
    extras::Dict{Symbol, Any}
    function Histogram{T}(bin_rule::Function) where T
        new{T}(bin_rule, Dict{T, Int}(), Dict{Symbol, Any}())
    end
end

## ------------------------------------------------------------
# Base
import Base.getproperty
function getproperty(h::Histogram, k::Symbol)
    hasfield(typeof(h), k) && return getfield(h, k)
    haskey(h.extras, k) && return getindex(h.extras, k)
    getfield(h, k)
end

import Base.propertynames
function propertynames(h::Histogram, ::Bool)
    _ps = fieldnames(Histogram) |> collect
    push!(_ps, keys(h.extras)...)
    return _ps
end

import Base.hasproperty
function hasproperty(h::Histogram, k::Symbol)
    hasfield(typeof(h), k) || haskey(h.extras, k)
end

import Base.haskey
haskey(h::Histogram, k::Symbol) = haskey(h.extras, k)

import Base.getindex
getindex(h::Histogram, k::Symbol) = getindex(h.extras, k)

import Base.setindex!
setindex!(h::Histogram, x, k::Symbol) = setindex!(h.extras, x, k)

import Base.keys
keys(h::Histogram) = keys(h.count_dict)
import Base.values
values(h::Histogram) = values(h.count_dict)

# ------------------------------------------------------------
function find_bin(h::Histogram{T}, v) where T
    x::T = h.bin_rule(h, v) # apply bin_rule
    isa(x, T) || error("Invalid bin_rule return type, expected: ", T, ", got: ", typeof(x))
    return x
end

bins(h::Histogram) = keys(h)
counts(h::Histogram) = values(h)
counts(h::Histogram{T}, k::T) where T = h.count_dict[k]
counts(h::Histogram{T}, ks::AbstractArray{T}) where T = [counts(h, k) for k in ks]
counts(h::Histogram{T}, ks::Base.KeySet{T}) where T = [counts(h, k) for k in ks]

import Base.count!
function count!(h::Histogram{T}, v) where T
    x::T = find_bin(h, v)
    count_dict::Dict{T, Int} = h.count_dict
    get!(count_dict, x, 0)
    count_dict[x] += 1
    return h
end

# Merge histograms
function count!(h0::Histogram{T}, h1::Histogram{T}, hs::Histogram{T}...) where T
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


## ------------------------------------------------------------
# Constructors

# range_histogram
function range_histogram(r::AbstractRange)
    rT = typeof(r)
    elT = eltype(r)
    # create histogram
    h = Histogram{elT}() do _h, v
        _bins::rT = _h.range
        ci = MetXBase._find_nearest(v, _bins)
        return _bins[ci]
    end
    # add extras
    h[:range] = r

    return h
end

function range_histogram(x0, x1; kwargs...)
    r = range(x0, x1; kwargs...)
    return range_histogram(r)
end

# identity_histogram
_identity(::Histogram{T}, v::T) where T = v
function identity_histogram(elT::DataType)
    h = Histogram{elT}(_identity)
    return h
end
