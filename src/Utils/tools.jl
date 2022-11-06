# make stuff dense
_dense_vecs(v) = (v isa SparseVector) ? Vector(v) : v

# TODO: make a dense/sparse api
dense_vecs(net::MetNet) = MetNet(net; 
    lb = _dense_vecs(net.lb),
    ub = _dense_vecs(net.ub),
    c = _dense_vecs(net.c),
    b = _dense_vecs(net.b),
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

_index_or_nothing(v, i, is...) = (isnothing(v) || isempty(v)) ? v : v[i, is...]