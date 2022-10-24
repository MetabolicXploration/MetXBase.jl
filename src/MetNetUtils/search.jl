# Search in some 'fields' for a match
export search
function search(fun::Function, net, hint; 
        maxprint = 50, 
        fields = [:rxns, :mets, :rxnNames, :metNames, :genes]
    )

    hint = string(hint)
    hint == "" && (println("0 found!!!"), return)

    fun_ = [] # custom filter
    eqs_ = [] # equals
    stw_ = [] # starts with
    ctn_ = [] # contains
    edw_ = [] # ends with

    up = uppercase
    up_hint = up(hint)
    for field in fields
        dat = getfield(net, field)
        push!(fun_, map(idx -> (dat[idx], idx), findall(fun, dat))...)
        push!(eqs_, map(idx -> (dat[idx], idx), findall(x-> up(x) == up_hint, dat))...)
        push!(stw_, map(idx -> (dat[idx], idx), findall(x-> startswith(up(x), up_hint), dat))...)
        push!(ctn_, map(idx -> (dat[idx], idx), findall(x-> occursin(up_hint, up(x)), dat))...)
        push!(edw_, map(idx -> (dat[idx], idx), findall(x-> endswith(up(x), up_hint), dat))...)
    end

    # print
    all_res = [sort!(fun_); sort!(eqs_); sort!(stw_); sort!(ctn_); sort!(edw_)] |> unique
    c = 0
    println("$(length(all_res)) found!!!")
    for (res, idx) in all_res
        
        print(idx, ": ")
        _print_highlights(res, hint; 
            bold = true,
            color = :red,
            underline = true
        )

        
        println()
        c == maxprint && (println("..."), return)
        c += 1
    end
end

search(net, hint; kwargs...) = search((x) -> false, net, hint; kwargs...)