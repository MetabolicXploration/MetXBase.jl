# The basic representation of a metabolic network
struct LEPModel{MT, VT} <: AbstractLEPModel
    
    # LEP data 
    # contraints
    # S ν = b 
    # ν ∈ [lb, ub]
    S::Union{Nothing, MT}
    b::Union{Nothing, VT}
    lb::Union{Nothing, VT}
    ub::Union{Nothing, VT}

    # optimizations coes
    # optarg_ν c'ν
    c::Union{Nothing, VT}
    # optarg_ν ν'Cν
    C::Union{Nothing, MT}
    
    # Meta
    colids::Union{Nothing, Array{String,1}} # an id for the columns of S
    rowids::Union{Nothing, Array{String,1}} # an id for the rows of S

    # Extras
    extras::Dict{Any, Any} # to store temp data

    function LEPModel(
            S, b, lb, ub, c, C, rowids, colids, 
            extras
        ) 
            MT = something(S, C, Some(nothing)) |> typeof
            VT = something(b, c, lb, ub, Some(nothing)) |> typeof
            return new{MT, VT}(
                S, b, lb, ub, c, C, rowids, colids, 
                extras
            )
    end 

end