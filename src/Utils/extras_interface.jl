# The extras system intend to add flexibility to the structures
# In must cases just a Dict

# TODO: pretty print extras
# TODO: create a cache_rebuild needed interface/recommendation

export extras
extras(obj) = error("Method extras(obj::$(obj))::Dict not defined")
extras(obj, k) = getindex(extras(obj), k)
extras(obj, k, dflt) = get(extras(obj), k, dflt)

export extras!
export extras!!
extras!(obj, k, val) = setindex!(extras(obj), val, k)
extras!(f::Function, obj, k) = setindex!(extras(obj), k, f())
extras!!(obj, k, dflt) = get!(extras(obj), k, dflt)
extras!!(f::Function, obj, k) = get!(f, extras(obj), k)

export hasextras
hasextras(obj, k) = haskey(extras(obj), k)

export empty_extra!
empty_extra!(obj) = empty!(extras(obj))

## ------------------------------------------------------------------
# API Utils

export @extras_dictlike_getsets
macro extras_dictlike_getsets(OT::Symbol, name::Symbol)
    name! = Symbol(string(name), "!")
    name!! = Symbol(string(name), "!!")
    _key = Symbol("_", (string(name)))
    quote
        # getters
        $(esc(name))(obj::$(esc(OT))) = extras!(() -> Dict(), obj, $(QuoteNode(_key)))
        $(esc(name))(obj::$(esc(OT)), k) = getindex($(esc(name))(obj), k)
        $(esc(name))(obj::$(esc(OT)), k, dflt) = get($(esc(name))(obj), k, dflt)
        $(esc(name))(f::Function, obj::$(esc(OT)), k) = get(f, $(esc(name))(obj), k)

        # setters
        $(esc(name!))(obj::$(esc(OT)), k, val) = setindex!($(esc(name))(obj), val, k)
        $(esc(name!))(f::Function, obj::$(esc(OT)), k) = setindex!($(esc(name))(obj), f(), k)
        function $(esc(name!))(obj::$(esc(OT)); kwargs...) 
            dict = $(esc(name))(obj)
            for (k, val) in kwargs
                setindex!(dict, val, k)
            end
            return obj
        end
        
        # get interface
        $(esc(name!!))(obj::$(esc(OT)), k, val) = get!($(esc(name))(obj), val, k)
        $(esc(name!!))(f::Function, obj::$(esc(OT)), k) = get!(f, $(esc(name))(obj), k)
        
    end 
end

export @extras_val_getsets
macro extras_val_getsets(OT::Symbol, name::Symbol, RT::Symbol)
    name! = Symbol(string(name), "!")
    _key = Symbol("_", (string(name)))
    quote
        # getters
        $(esc(name))(obj::$(esc(OT)))::Union{Nothing, $(esc(RT))} = extras(obj, $(QuoteNode(_key)), nothing)
        # setters
        $(esc(name!))(obj::$(esc(OT)), val::Union{Nothing, $(esc(RT))}) = extras!(obj, $(QuoteNode(_key)), val)    
    end
end
