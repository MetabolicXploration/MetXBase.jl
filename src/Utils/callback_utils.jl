run_callbacks(::Nothing, arg, args...) = nothing
run_callbacks(cb::Function, arg, args...) = cb(arg, args...)
function run_callbacks(cbs::Vector, arg, args...)
    val = nothing
    for cb in cbs
        val = run_callbacks(cb, arg, args...)
    end
    return val
end