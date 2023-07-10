# Search in some 'fields' for a match
# TODO: Make a more powerful search engine (use StringRepFilter?)
function search(fun::Function, net, hint, fields; 
        maxprint = 50, 
    )

    hint = string(hint)
    hint == "" && (println("0 found!!!"), return)

    fun_ = [] # custom filter
    eqs_ = [] # equals
    stw_ = [] # starts with
    ctn_ = [] # contains
    edw_ = [] # ends with

    up = (x) -> uppercase(string(x))
    up_hint = up(hint)
    for field in fields
        dat = getfield(net, field)
        isnothing(dat) && continue
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

search(net, hint, fields; kwargs...) = search((x) -> false, net, hint, fields; kwargs...)