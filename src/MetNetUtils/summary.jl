import Base.summary
function summary(io::IO, net::MetNet; 
        print_max = 50, 
        full = false
    )
    
    _print_summary_head(io)
    _summary_bound_state(io, net; print_max)

    full || return nothing
    # histograms
    _println_order_summary(net.S; 
        title = "Stoichiometric Matrix", 
        ylabel = "log10(|S|)",
        fout = (vi) -> !iszero(vi),
        vT = (vi) -> log10(abs(vi))
    )

    _println_order_summary([net.lb; net.ub]; 
        title = "Bounds", 
        ylabel = "[lb; ub]",
        fout = (vi) -> true,
        vT = identity
    )

end

summary(net::MetNet; kwargs...) = summary(stdout, net; kwargs...)

function summary(io::IO, net::MetNet, ider)
    _print_summary_head(io)
    try
        _print_rxn_summary(io, net, ider)
        println()
    catch end
    try
        _print_met_summary(io, net, ider)
        println()
    catch end
end
summary(net::MetNet, ider) = summary(stdout, net, ider)

# ------------------------------------------------------------------
# utils
# TODO: make an interface
const WARN_COLOR = :yellow
const INFO_COLOR = :blue
const ERROR_COLOR = :red

function _print_summary_head(io::IO)
    print(io, "SUMMARY (color code: ")
    printstyled(io, "warning", color = WARN_COLOR)
    printstyled(io, ", info", color = INFO_COLOR)
    printstyled(io, ", error", color = ERROR_COLOR)
    println(io, ")")
end

function _summary_bound_state(io::IO, net::MetNet; print_max = 50)
    
    M, N = size(net)

    all(iszero(net.lb)) && all(iszero(net.ub)) && 
        (printstyled(io, "lb and ub boths has only zero elements", "\n", color = ERROR_COLOR); return)
    
    # single checks
    for (name, col) in zip(["lb", "ub"], [net.lb, net.ub])
        _print_col_summary(io, col, name; expected_l = N, print_max = print_max)
    end

    # Counple checks
    line_count = 0
    for (i, rxn) in enumerate(net.rxns)
        lb = net.lb[i]
        ub = net.ub[i]
        lb > ub && (printstyled(io, "rxn($i): ($rxn), lb ($lb) > ub ($ub)", 
            "\n", color = ERROR_COLOR); line_count += 1)
        lb > 0.0 && (printstyled(io, "rxn($i): ($rxn), lb ($lb) > 0.0", 
            "\n", color = WARN_COLOR); line_count += 1)
        ub < 0.0 && (printstyled(io, "rxn($i): ($rxn), ub ($ub) < 0.0", 
            "\n", color = WARN_COLOR);  line_count += 1)
        lb == ub && (printstyled(io, "rxn($i): ($rxn), lb ($lb) == ub ($ub)", 
            "\n", color = WARN_COLOR); line_count += 1)

        if line_count > print_max
            printstyled(io, "print_max $print_max reached!!! ... ", "\n", color = WARN_COLOR)
            break;
        end
        flush(stdout)
    end

    revscount(net) > 0 && printstyled(io, "revscount: $(revscount(net))", "\n", color = WARN_COLOR)
    fwds_boundedcount(net) > 0 && printstyled(io, "fwds bounded: $(fwds_boundedcount(net))", "\n", color = INFO_COLOR)
    bkwds_boundedcount(net) > 0 && printstyled(io, "bkwds bounded: $(bkwds_boundedcount(net))", "\n", color = WARN_COLOR)
    blockscount(net) > 0 && printstyled(io, "blocks: $(blockscount(net))", "\n", color = WARN_COLOR)
    fixxedscount(net) > 0 && printstyled(io, "fixxed: $(fixxedscount(net))", "\n", color = INFO_COLOR)
    
    println()
    return nothing
end

function _print_col_summary(io::IO, col, name; 
        expected_l = length(col), 
        print_max = 50)

        length(col) != expected_l && (printstyled(io, 
            " $name: ($(length(col))) != N ($expected_l), dimention missmatch", 
            "\n", color = ERROR_COLOR); return)
    
        unique_ = sort!(unique(col))
        length(unique_) < print_max ?
            printstyled(io, " $name: $(length(unique_)) unique elment(s): ", unique_, "\n", color = INFO_COLOR) :
            printstyled(io, " $name: $(length(unique_)) unique elment(s): min: ", 
                first(unique_), " mean: ", mean(col),
                " max: ", last(unique_), "\n", color = INFO_COLOR)

end

# ------------------------------------------------------------------
# Rxns
function _print_rxn_summary(io::IO, net, ider)
    idx = rxnindex(net, ider)
    printstyled(io, " rxn[$idx]: ", net.rxns[idx], " (", get(net.rxnNames, idx, ""), ")\n", color = INFO_COLOR)
    printstyled(io, " lb: ", net.lb[idx], ", ub: ", net.ub[idx], "\n" , color = INFO_COLOR)
    printstyled(io, " ", rxn_str(net, idx), "\n" , color = INFO_COLOR)
end

# ------------------------------------------------------------------
# Mets
function _print_met_summary(io::IO, net, ider)
    idx = metindex(net, ider)
    printstyled(io, " met[$idx]: ", net.mets[idx], " (", get(net.metNames, idx, ""), ")\n", color = INFO_COLOR)
    printstyled(io, " ", balance_str(net, ider), color = INFO_COLOR)
end

