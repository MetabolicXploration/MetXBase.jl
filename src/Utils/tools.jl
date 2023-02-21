_dense(v::AbstractSparseMatrix) = Matrix(v)
_dense(v::AbstractSparseVector) = Vector(v)
_dense(v::AbstractArray) = v

# TODO: make a dense/sparse api
dense_vecs(net::MetNet) = MetNet(net; 
    lb = _dense(net.lb),
    ub = _dense(net.ub),
    c = _dense(net.c),
    b = _dense(net.b),
)

export extract_fields
function extract_fields(obj, fields = fieldnames(typeof(obj)))
    sdict = Dict{Symbol, Any}()
    for f in fields
        v = getfield(obj, f)
        sdict[f] = v
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
_setindex!(vec, idxs::Int, val) = (vec[idxs] = val)
_setindex!(vec, idxs, val) = (vec[idxs] .= val)

_setindex!(mat, idx0::Int, idx1::Int, val) = (mat[idx0, idx1] = val)
_setindex!(mat, idx0, idx1, val) = (mat[idx0, idx1] .= val)

_getindex_or_nothing(v, i, is...) = (isnothing(v) || isempty(v)) ? v : v[i, is...]

function _resize_or_nothing(v0::AbstractArray, fillv, d1, ds...)
    v1 = fill(fillv, d1, ds...)
    N = min(length(v0), length(v1))
    for i in 1:N; v1[i] = v0[i]; end
    return v1
end
_resize_or_nothing(v0::Nothing, fillv, d1, ds...) = v0

_length_or_nothing(v0) = length(v0)
_length_or_nothing(::Nothing) = nothing

_get(::Nothing, idx, dflt) = dflt
_get(col, idx, dflt) = get(col, idx, dflt)

_copy(x) = copy(x)
_copy(::Nothing) = nothing

function _find_nearest(x::Real, x0::Real, dx::Real)
    i, d = divrem(x - x0, dx)
    return d < (dx / 2) ? Int(i)+1 : Int(i)+2
end

function _find_nearest(x::Real, r::AbstractRange)
    x0, x1 = extrema(r)
    x0 > x && return firstindex(r)
    x1 < x && return lastindex(r)
    return _find_nearest(x, x0, step(r))
end

function _histogram!(bins::AbstractRange, hist::AbstractVector, vi::Number, wi::Number)
    nearest = _find_nearest(vi, bins)
    hist[nearest] += wi
end
function _histogram!(bins::AbstractRange, hist::AbstractVector, vs::AbstractVector, ws::AbstractVector)
    for i in eachindex(vs)
        _histogram!(bins, hist, vs[i], ws[i])
    end
    return (bins, hist)
end

function _histogram(vs::AbstractVector, ws::AbstractVector, nbins)
    v0, v1 = extrema(vs)
    bins = range(v0, v1; length = nbins)
    hist = zeros(nbins)
    _histogram!(bins, hist, vs, ws)
end
_histogram(vs::AbstractVector, w::Number, nbins) =
    _histogram(vs, ones(length(vs)) .* w, nbins)

function _isapprox(x0, xs...; kwargs...)
    for x in xs
        isapprox(x0, x; kwargs...) || return false
    end
    return true
end