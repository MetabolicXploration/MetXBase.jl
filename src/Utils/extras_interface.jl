# The extras system intend to add flexibility to the structures
# In must cases just a Dict

# TODO: pretty print extras

export set_extra!
set_extra!(obj, k, val) = setindex!(get_extra(obj), val, k)

export get_extra
get_extra(obj) = error("Method get_extra(obj::$(obj))::Dict not defined")
get_extra(obj, k) = getindex(get_extra(obj), k)
get_extra(obj, k, dflt) = get(get_extra(obj), k, dflt)
get_extra!(obj, k, dflt) = get!(get_extra(obj), k, dflt)

export empty_extra!
empty_extra!(obj) = empty!(get_extra(obj))
