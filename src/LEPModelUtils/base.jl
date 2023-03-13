# LEPModel
import Base.size
size(lep::LEPModel) = size(lep.S)
size(lep::LEPModel, dim) = size(lep.S, dim)

import Base.==
function ==(lep1::AbstractLEPModel, lep2::AbstractLEPModel)
    rowids(lep1) == rowids(lep2) || return false
    colids(lep1) == colids(lep2) || return false
    lb(lep1) == lb(lep2) || return false
    ub(lep1) == ub(lep2) || return false
    balance(lep1) == balance(lep2) || return false
    cost_matrix(lep1) == cost_matrix(lep2) || return false
    return true
end

import Base.isequal
isequal(lep1::LEPModel, lep2::LEPModel) = (lep1 == lep2)

import Base.hash
function hash(lep::LEPModel, h::Int = 0) 
    h += hash(:LEPModel)
    h = hash(lep.S, h)
    h = hash(lep.b, h)
    h = hash(lep.lb, h)
    h = hash(lep.ub, h)
    return h
end

import Base.show
show(io::IO, lep::LEPModel) = (println(io, "LEPModel ", size(lep)))

import Base.big
function Base.big(lep::LEPModel)
    return LEPModel(lep; 
        S = _collect_or_nothing(BigFloat, lep.S),
        b = _collect_or_nothing(BigFloat, lep.b), 
        lb = _collect_or_nothing(BigFloat, lep.lb), 
        ub = _collect_or_nothing(BigFloat, lep.ub), 
        c = _collect_or_nothing(BigFloat, lep.c), 
        C = _collect_or_nothing(BigFloat, lep.C) 
    )
end