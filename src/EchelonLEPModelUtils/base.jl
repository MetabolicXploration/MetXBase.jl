import Base.show
# show(io::IO, elep::EchelonLEPModel) = (println(io, "EchelonLEPModel"); summary(io, elep))
show(io::IO, elep::EchelonLEPModel) = println(io, "EchelonLEPModel ", size(elep))


import Base.size
size(elep::EchelonLEPModel) = size(elep.lep)