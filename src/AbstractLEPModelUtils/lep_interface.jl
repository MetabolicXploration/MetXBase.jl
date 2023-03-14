# A common interface for handling a LEPModel-like objects
# Method to implement 
# - lepmodel(obj)::LEPModel
# - rowids(obj)::Vector{String} accessor to rows ids
# - colids(obj)::Vector{String} accessor to columns ids

# default for all AbstractLEPModel
lepmodel(lep::AbstractLEPModel) = lep

rowids(obj, ider) = rowids(obj)[rowindex(obj, ider)]
colids(obj, ider) = colids(obj)[colindex(obj, ider)]