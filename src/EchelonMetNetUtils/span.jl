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

export isfeasible_vf!
function isfeasible_vf!(v::Vector, lb::Vector, ub::Vector;
       testfree = true
    )

    # Test dependent
    for i in enet.idxd
        v[i] < lb[i] && return false
        v[i] > ub[i] && return false
    end

    # Test free
    testfree || return true
    for i in enet.idxf
        v[i] < lb[i] && return false
        v[i] > ub[i] && return false
    end

    return true
end

function isfeasible_vf!(v::Vector, enet::EchelonMetNet, vf::Vector;
        testfree = true
    )
    span!(v, enet, vf)
    lb = enet.net.lb
    ub = enet.net.ub
    return isfeasible_vf!(v, lb, ub; testfree)
end

export isfeasible_vf
isfeasible_vf(enet::EchelonMetNet, vf::Vector; testfree = true) = 
    isfeasible_vf!(zeros(size(enet, 2)), enet, vf; testfree)

