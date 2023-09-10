function _hasid(model, getter, ider::AbstractString)
    ids = getter(model)
    isnothing(ids) && return false
    return !isnothing(findfirst(isequal(ider), ids))
end

hasrowid(model, ider) = _hasid(model, rowids, ider)
rowindex(model, ider) = _getindex(model, rowids, ider)

hascolid(model, ider) = _hasid(model, colids, ider)
colindex(model, ider) = _getindex(model, colids, ider)
