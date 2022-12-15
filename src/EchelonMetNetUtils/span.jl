# --------------------------------------------
# TODO: Use this kind of interface in other places where im recicling 
# a vector to avoid allocations (e.g. sample!)
export span!
function span!(v::Vector, enet::EchelonMetNet, vf::Vector)
    v[enet.idxd] .= enet.net.b - enet.G * vf
    v[enet.idxf] .= vf
    return v
end

export span
span(enet::EchelonMetNet, vf::Vector) = span!(zeros(size(enet, 2)), enet, vf)