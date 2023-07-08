# TODO: Revise this
import Base.summary
function summary(io::IO, elep::EchelonLEPModel; 
        print_max = 50
    )
    
    _print_summary_head(io)
    _print_stoi_summary(io, metnet(elep))
    
    printstyled(io, string("free rxns: ", length(elep.idxf)), color = INFO_COLOR)
    println(io)
    printstyled(io, string("dep rxns: ", length(elep.idxd)), color = INFO_COLOR)
    println(io)

    _print_ider_summary(io, metnet(elep))
    _summary_bound_state(io, metnet(elep); print_max)

end

summary(elep::EchelonLEPModel; print_max = 50) = summary(stdout, elep; print_max)