import Base.size
size(lep::AbstractLEPModel, args...) = size(lepmodel(lep), args...)