function balance_str(net::MetNet, ider; digits = 50)
    meti = metindex(net, ider)
    rxns = net.rxns[met_rxns(net, ider)] |> sort
    b_str = []
    for rxn in rxns
        s = round(stoi(net, meti, rxn), digits = digits)
        push!(b_str, "($s)$rxn")
    end
    return "$(net.mets[meti]): " * join(b_str, " + ") * " == " * 
                "$(round(net.b[meti], digits = digits))"
end

