# MetNet
import Base.size
size(net::MetNet) = size(net.S)
size(net::MetNet, dim) = size(net.S, dim)

import Base.==
function ==(net1::MetNet, net2::MetNet)
    return net1.S == net2.S && net1.lb == net2.lb &&
    net1.ub == net2.ub && net1.mets == net2.mets &&
    net1.rxns == net2.rxns
end

import Base.isequal
isequal(net1::MetNet, net2::MetNet) = (net1 == net2)

import Base.hash
function hash(m::MetNet, h::Int = 0) 
    h += hash(:MetNet)
    h = hash(m.S, h)
    h = hash(m.b, h)
    h = hash(m.lb, h)
    h = hash(m.ub, h)
    return h
end

import Base.show
show(io::IO, m::MetNet) = (println(io, "MetNet"); summary(io, m))

import Base.empty!
_empty!(::Nothing) = nothing
_empty!(o) = empty!(o)
empty!(m::MetNet, fields = fieldnames(typeof(m))) =
    foreach((f) -> _empty!(getfield(m, f)), fields)