import Base.summary
function summary(io::IO, enet::EchelonMetNet; 
        print_max = 50
    )
    
    _print_summary_head(io)
    _print_stoi_summary(io, metnet(enet))
    
    printstyled(io, string("free rxns: ", length(enet.idxf)), color = INFO_COLOR)
    println(io)
    printstyled(io, string("dep rxns: ", length(enet.idxd)), color = INFO_COLOR)
    println(io)

    _print_ider_summary(io, metnet(enet))
    _summary_bound_state(io, metnet(enet); print_max)

end

summary(enet::EchelonMetNet; print_max = 50) = summary(stdout, enet; print_max)