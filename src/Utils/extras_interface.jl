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
extras!(f::Function, obj, k) = setindex!(extras(obj), f(), k)
extras!!(obj, k, dflt) = get!(extras(obj), k, dflt)
extras!!(f::Function, obj, k) = get!(f, extras(obj), k)

export hasextras
hasextras(obj, k) = haskey(extras(obj), k)

export empty_extra!
empty_extra!(obj) = empty!(extras(obj))

## ------------------------------------------------------------------
# API Utils

export @extras_dict_interface
macro extras_dict_interface(OT::Symbol, name::Symbol)

    # names
    name! = Symbol(string(name), "!")
    name!! = Symbol(string(name), "!!")

    # check if defined
    isdef = all(isdefined.([MetXBase], [name, name!, name!!]))
    isdef || error("Interface `$name` not defined on MetXBase")

    _key = Symbol("_", (string(name)))
    quote
        # import from MetXBase
        import MetXBase.$(name)
        import MetXBase.$(name!)
        import MetXBase.$(name!!)

        # getters
        $(esc(name))(obj::$(esc(OT))) = extras!!(() -> Dict(), obj, $(QuoteNode(_key)))
        $(esc(name))(obj::$(esc(OT)), k) = getindex($(esc(name))(obj), k)
        $(esc(name))(obj::$(esc(OT)), k, dflt) = get($(esc(name))(obj), k, dflt)
        $(esc(name))(f::Function, obj::$(esc(OT)), k) = get(f, $(esc(name))(obj), k)

        # setters
        # setindex!(collection, value, key...)
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
        # get!(collection, key, default)
        $(esc(name!!))(obj::$(esc(OT)), k, val) = get!($(esc(name))(obj), k, val)
        $(esc(name!!))(f::Function, obj::$(esc(OT)), k) = get!(f, $(esc(name))(obj), k)
        
    end 
end

export @extras_val_interface
macro extras_val_interface(OT::Symbol, name::Symbol, RT::Symbol)

    # names
    name! = Symbol(string(name), "!")
    
    # check if defined
    isdef = all(isdefined.([MetXBase], [name, name!]))
    isdef || error("Interface `$name` not defined on MetXBase")

    _key = Symbol("_", (string(name)))
    quote
        # import from MetXBase
        import MetXBase.$(name)
        import MetXBase.$(name!)

        # getters
        $(esc(name))(obj::$(esc(OT))) = extras(obj, $(QuoteNode(_key)))::$(esc(RT))
        $(esc(name))(obj::$(esc(OT)), deft::T) where T = 
            extras(obj, $(QuoteNode(_key)), deft)::Union{T, $(esc(RT))}
        # setters
        $(esc(name!))(obj::$(esc(OT)), val::$(esc(RT))) = extras!(obj, $(QuoteNode(_key)), val)    
    end
end

# ------------------------------------------------------------------
macro reg_extras_val_interface(name::Symbol)
    # names
    name! = Symbol(string(name), "!")
    return quote
        export $(name), $(name!)

        function $(esc(name)) end
        function $(esc(name!)) end
    end
end

macro reg_extras_dict_interface(name::Symbol)
    # names
    name! = Symbol(string(name), "!")
    name!! = Symbol(string(name), "!!")

    return quote
        export $(name), $(name!), $(name!!)

        function $(esc(name)) end
        function $(esc(name!)) end
        function $(esc(name!!)) end
    end
end

## ------------------------------------------------------------------
# Interfaces Register

# metnet
@reg_extras_val_interface metnet

# config
@reg_extras_dict_interface config

# state
@reg_extras_dict_interface state

