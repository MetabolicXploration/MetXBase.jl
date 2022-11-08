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
hash(m::MetNet, h::Int = 0) = hash((:MetNet, m.S, m.b, m.lb, m.ub, h))

import Base.show
show(io::IO, m::MetNet) = summary(io, m)

import Base.empty!
_empty!(::Nothing) = nothing
_empty!(o) = empty!(o)
empty!(m::MetNet, fields = fieldnames(typeof(m))) =
    foreach((f) -> _empty!(getfield(m, f)), fields)