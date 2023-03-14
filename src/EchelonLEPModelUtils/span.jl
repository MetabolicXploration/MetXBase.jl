# --------------------------------------------
# TODO: Use this kind of interface in other places where im recicling 
# a vector to avoid allocations (e.g. sample!)
function span!(v::Vector, elep::EchelonLEPModel, vf::Vector)
    v[elep.idxd] .= elep.lep.b - elep.G * vf
    v[elep.idxf] .= vf
    return v
end

span(elep::EchelonLEPModel, vf::Vector) = span!(zeros(size(elep, 2)), elep, vf)

function isfeasible_vf!(v::Vector, lb::Vector, ub::Vector;
       testfree = true
    )

    # Test dependent
    for i in elep.idxd
        v[i] < lb[i] && return false
        v[i] > ub[i] && return false
    end

    # Test free
    testfree || return true
    for i in elep.idxf
        v[i] < lb[i] && return false
        v[i] > ub[i] && return false
    end

    return true
end

function isfeasible_vf!(v::Vector, elep::EchelonLEPModel, vf::Vector;
        testfree = true
    )
    span!(v, elep, vf)
    return isfeasible_vf!(v, elep.lep.lb, elep.lep.ub; testfree)
end

isfeasible_vf(elep::EchelonLEPModel, vf::Vector; testfree = true) = 
    isfeasible_vf!(zeros(size(elep, 2)), elep, vf; testfree)

