# This will allow to refer elements by different ider representations (e.g. Int or String)

const _IDER_TYPE = Union{Integer, AbstractString, Symbol}
_getindex(model, getter, ider::Integer) = ider
function _getindex(model, getter, ider::AbstractString) 
    indx = findfirst(isequal(ider), getter(model))
    isnothing(indx) && error("ider ($ider) not found, getter: $(nameof(getter))") 
    return indx
end
_getindex(model, getter, ider::Symbol) = _getindex(model, getter, string(ider))
_getindex(model, getter, ider::AbstractUnitRange{Int64}) = ider
_getindex(model, getter, ::Colon) = isnothing(getter(model)) ? Colon() : eachindex(getter(model))

_getindex(model, getter, ider::Vector{<:Integer}) = ider
_getindex(model, getter, ider::Vector{Bool}) = ider
_getindex(model, getter, ider::BitVector) = ider
_getindex(model, getter, iders::Vector) = [_getindex(model, getter, ider) for ider in iders]

# _getindex(model, getter, iders) = error

export metindex
metindex(model, ider) = _getindex(model, metabolites, ider)

export rxnindex
rxnindex(model, ider) = _getindex(model, reactions, ider)

export geneindex
geneindex(model, ider) = _getindex(model, genes, ider)

