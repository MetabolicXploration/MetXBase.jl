# --------------------------------------------
# TODO: Use this kind of interface in other places where im recicling 
# a vector to avoid allocations (e.g. sample!)
function span!(v::Vector, elep::EchelonLEPModel, vi::Vector)
    v[elep.idxd] .= elep.lep.b - elep.G * vi
    v[elep.idxi] .= vi
    return v
end

span(elep::EchelonLEPModel, vi::Vector) = span!(zeros(size(elep, 2)), elep, vi)

# function isfeasible_vf!(v::Vector, elep::EchelonLEPModel, lb::Vector, ub::Vector;
#        testfree = true
#     )

#     # Test dependent
#     for i in elep.idxd
#         v[i] < lb[i] && return false
#         v[i] > ub[i] && return false
#     end

#     # Test free
#     testfree || return true
#     for i in elep.idxi
#         v[i] < lb[i] && return false
#         v[i] > ub[i] && return false
#     end

#     return true
# end

function isfeasible_vf!(v::Vector, elep::EchelonLEPModel, vi::Vector;
        testfree = true
    )
    span!(v, elep, vi)
    
    # Test dependent
    lb, ub = elep.lep.lb, elep.lep.ub
    for i in elep.idxd
        v[i] < lb[i] && return false
        v[i] > ub[i] && return false
    end

    # Test free
    testfree || return true
    for i in elep.idxi
        v[i] < lb[i] && return false
        v[i] > ub[i] && return false
    end

    return true

    # return isfeasible_vf!(v, elep.lep, elep.lep.lb, elep.lep.ub; testfree)
end

isfeasible_vf(elep::EchelonLEPModel, vi::Vector; testfree = true) = 
    isfeasible_vf!(zeros(size(elep, 2)), elep, vi; testfree)

