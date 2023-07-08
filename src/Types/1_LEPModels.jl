# From: https://doi.org/10.6092/polito/porto/2669186
# The problems that will be described in the following part of the chapter can be seen as
# particular cases of a more general problem, the linear estimation problem (LEP). This
# type of problem consists in determining a vector $v \in R_N$ that satisfies a system of linear equations of the type
# $$\begin{align}
# \tag{2.2.1}
# Sv = b
# \end{align}$$
# where $S \in R^{M \times N}$ and $b \in R^M$ are known and $N > M$ . The system in (2.2.1) is ill-posed and, 
# mathematically speaking, there exists an infinite number of solutions satisfying the linear constraints; 
# nonetheless the domain of research can be significantly reduced if one makes further assumptions concerning 
# the desired solution. These problems can be faced using very different techniques. We will shortly show how to deal 
# with LEP using linear programming in section §3.6.1 but the main approaches utilized in this thesis rely on the 
# Bayesian inference. We will encode within the posterior probability of the unknowns all the available information about 
# the system along with the hard constraints that variables $v$ must satisfy.

Base.@kwdef struct LEPModel{MT, VT} <: AbstractLEPModel
    
    # LEP data 
    # contraints
    # S ν = b 
    # ν ∈ [lb, ub]
    S::Union{Nothing, MT} = nothing
    b::Union{Nothing, VT} = nothing
    lb::Union{Nothing, VT} = nothing
    ub::Union{Nothing, VT} = nothing

    # optimizations coes
    # optarg_ν c'ν
    c::Union{Nothing, VT} = nothing
    # optarg_ν ν'Cν
    C::Union{Nothing, MT} = nothing
    
    # Meta
    # an id for the rows of S
    rowids::Union{Nothing, Array{String,1}} = nothing
    # an id for the columns of S 
    colids::Union{Nothing, Array{String,1}} = nothing

    # Extras (to store temp data)
    extras::Dict{Any, Any} = Dict{Any, Any}()

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

"""
    Create a new LEPModel from a template but overwriting the fields
    of the template with the given as kwargs.
    The returned LEPModel will share the non-overwritten fields.
"""
function LEPModel(template::LEPModel; to_overwrite...)
    
    new_dict = Dict{Symbol, Any}(to_overwrite)

    for field in fieldnames(typeof(template))
        haskey(new_dict, field) && continue # avoid use the template version
        new_dict[field] = getfield(template, field)
    end
    
    return LEPModel(;new_dict...)
end