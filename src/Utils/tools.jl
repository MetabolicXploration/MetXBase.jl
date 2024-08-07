_dense(v::AbstractSparseMatrix) = Matrix(v)
_dense(v::AbstractSparseVector) = Vector(v)
_dense(v) = v

_sparse(v::AbstractArray) = sparse(v)
_sparse(v) = v

function extract_fields(obj, fields = fieldnames(typeof(obj)); keymap = Symbol)
    sdict = Dict()
    for f in fields
        v = getfield(obj, f)
        sdict[keymap(f)] = v
    end
    return sdict
end

const _sci_pool = Dict{Int, Symbol}()
let
    empty!(_sci_pool)
    ds = 1:10
    for d in ds
        srtf = "%0.$(d)e"
        fun = Symbol("_sci", d)
        @eval begin
            $fun(n) = @sprintf($srtf, n)
        end
        _sci_pool[d] = fun
    end
end
function sci_str(n, d::Int = 1) 
    d = clamp(d, 1, 10)
    scifun = getproperty(@__MODULE__, _sci_pool[d])
    scifun(n)
end

function num_str(n, d=1)
    (abs(n) < 1e-3 || abs(n) > 1e3) ? sci_str(n, d) : string(round(n; digits = d))
end

function _nbins(v; n0 = 5, n1 = 10)
    o0, o1 = extrema(v)
    return clamp(floor(Int, o1 - o0), n0, n1)
end

function _println_order_summary(io::IO, v; 
        title, ylabel,
        fout = (vi) -> true, 
        vT = identity
    )

    println(io, "="^60)
    println(io, title, " ", size(v))
    println(io, "."^60)
    v = filter(fout, v)
    v = vT.(v)
    h = histogram(v;
        nbins = _nbins(v),
        closed=:left, 
        canvas=DotCanvas, 
        title = string("Frequency of ", ylabel), 
        xlabel = "", 
        yscale=:log10
    ) 
    println(io, h)
    println()
end
_println_order_summary(v; kwargs...) = _println_order_summary(stdout, v; kwargs...)

# solve broadcast issue
_setindex!(vec, val) = (vec .= val)
_setindex!(vec, idxs::Integer, val) = (vec[idxs] = val)
_setindex!(vec, idxs, val) = (vec[idxs] .= val)

_setindex!(mat, idx0::Integer, idx1::Integer, val) = (mat[idx0, idx1] = val)
_setindex!(mat, idx0, idx1, val) = (mat[idx0, idx1] .= val)

_setindex_or_nothing!(v, i, val) = (isnothing(v) || isempty(v)) ? v : setindex!(v, val, i)
_setindex_or_nothing!(v, i1, i2, val) = (isnothing(v) || isempty(v)) ? v : setindex!(v, val, i1, i2)
_getindex_or_nothing(v, i, is...) = (isnothing(v) || isempty(v)) ? v : v[i, is...]

_collect_or_nothing(T, v) = isnothing(v) ? v : collect(T, v)
_collect_or_nothing(v) = isnothing(v) ? v : collect(eltype(v), v)

function _resize_or_nothing(v0::AbstractArray, fillv, d1, ds...)
    v1 = fill(fillv, d1, ds...)
    # @show v1
    for i in eachindex(IndexCartesian(), v0)
        checkbounds(Bool, v1, i) || continue
        v1[i] = v0[i]
    end
    return v1
end
_resize_or_nothing(v0::Nothing, _...) = v0

_length_or_nothing(v0) = length(v0)
_length_or_nothing(::Nothing) = nothing

_get(::Nothing, idx, dflt) = dflt
_get(col, idx, dflt) = get(col, idx, dflt)

_copy(x) = copy(x)
_copy(::Nothing) = nothing

function _find_nearest(x::Real, x0::Real, dx::Real)
    iszero(dx) && return 1
    isnan(x) && return NaN
    i, d = divrem(x - x0, dx)
    # @show i, d
    return d < (dx / 2) ? Int(i)+1 : Int(i)+2
end

function _find_nearest(x::Real, r::AbstractRange)
    x0, x1 = extrema(r)
    x0 > x && return firstindex(r)
    x1 < x && return lastindex(r)
    return _find_nearest(x, x0, step(r))
end

_sqerr(ri, x) = (x - ri)^2
_sqerr(x) = Base.Fix2(_sqerr, x)

_find_nearest(x::Real, r::AbstractVector) = last(findmin(_sqerr(x), r))

# TODO: deprecate
function _histogram!(bins::AbstractVector, hist::AbstractVector, vi::Number, wi::Number = one(vi))
    nearest = _find_nearest(vi, bins)
    hist[nearest] += wi
end
function _histogram!(bins::AbstractVector, hist::AbstractVector, vs::AbstractVector, ws::AbstractVector = one.(vs))
    for i in eachindex(vs)
        _histogram!(bins, hist, vs[i], ws[i])
    end
    return (bins, hist)
end

function _histogram(bins::AbstractVector, vs::AbstractVector, ws::AbstractVector)
    hist = zeros(length(bins))
    _histogram!(bins, hist, vs, ws)
end
_histogram(bins::AbstractVector, vs::AbstractVector) =
    _histogram(bins, vs, ones(length(vs)))

function _histogram(vs::AbstractVector, ws::AbstractVector, nbins::Integer)
    v0, v1 = extrema(vs)
    bins = range(v0, v1; length = nbins)
    _histogram(bins, vs, ws)
end
_histogram(vs::AbstractVector, w::Number, nbins::Integer) =
    _histogram(vs, ones(length(vs)) .* w, nbins)

_histogram(vs::AbstractVector, nbins::Integer) =
    _histogram(vs, ones(length(vs)), nbins)

function _isapprox(x0, xs...; kwargs...)
    for x in xs
        isapprox(x0, x; kwargs...) || return false
    end
    return true
end

_unbig(x; digits = 15) = round(Float64(x); digits)

_checkbounds(vec, I...) = checkbounds(Bool, vec, I...)
_checkbounds(::Nothing, I...) = false
