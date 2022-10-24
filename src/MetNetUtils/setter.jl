export stoi!
stoi!(net::MetNet, metider, rxnider, s) =   
    (net.S[metindex(net, metider), rxnindex(net, rxnider)] .= s; net)

export balance!
balance!(net::MetNet, metider, val) = 
    (net.b[metindex(net, metider)] .= val; net)

export ub!
ub!(net::MetNet, rxnider, val) = 
    (net.ub[rxnindex(net, rxnider)] .= val; net)

export lb!
lb!(net::MetNet, rxnider, val) = 
    (net.lb[rxnindex(net, rxnider)] .= val; net)

export bounds!
function bounds!(net::MetNet, ider, lb, ub)
    idx = rxnindex(net, ider)
    ub!(net, idx, ub)
    lb!(net, idx, lb)
    return net
end

function bounds!(net::MetNet, ider;
        lb = nothing,
        ub = nothing,
    )
    idx = rxnindex(net, ider)
    isnothing(ub) || ub!(net, idx, ub)
    isnothing(lb) || lb!(net, idx, lb)
    return net
end
