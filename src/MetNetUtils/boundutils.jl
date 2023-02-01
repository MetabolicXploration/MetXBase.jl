export fixxing
function fixxing(f::Function, net::MetNet, ider, val; dv = 0.0)
    
    idx = rxnindex(net, ider)

    # backup
    lb0, ub0 = lb(net, idx), ub(net, idx)

    # fix!
    ub!(net, idx, val + dv)
    lb!(net, idx, val - dv)

    ret = f(net)
    
    # restore
    lb!(net, idx, lb0)
    ub!(net, idx, ub0)

    return ret
end

export clamplb!
clamplb!(net::MetNet, b0, b1) = (net.lb .= clamp.(net.lb, b0, b1); net)

export clampub!
clampub!(net::MetNet, b0, b1) = (net.ub .= clamp.(net.ub, b0, b1); net)

export clampbounds!
clampbounds!(net::MetNet, b0, b1) = 
    (clamplb!(net, b0, b1); clampub!(net, b0, b1); net)
