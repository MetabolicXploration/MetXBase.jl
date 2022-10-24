# This will allow to refer elements by different ider representations (e.g. Int or String)

_getindex(model, getter, ider::Integer) = ider
_getindex(model, getter, ::Colon) = eachindex(getter(model))
_getindex(model, getter, ider::UnitRange) = ider
_getindex(model, getter, ider::Vector{<:Integer}) = ider
_getindex(model, getter, iders::Vector{<:AbstractString}) = [_getindex(model, getter, ider) for ider in iders]
function _getindex(model, getter, ider::AbstractString) 
    indx = findfirst(isequal(ider), getter(model))
    isnothing(indx) && error("ider ($ider) not found, getter: $(nameof(getter))") 
    return indx
end
_getindex(model, getter, iders) = (eltype(iders) <: AbstractString) ?
        [_getindex(model, getter, ider) for ider in iders] : iders

# This will allow to refer elements by different ider representations (e.g. Int or String)
export metindex
metindex(model, ider) = _getindex(model, metabolites, ider)

export rxnindex
rxnindex(model, ider) = _getindex(model, reactions, ider)

export geneindex
geneindex(model, ider) = _getindex(model, genes, ider)