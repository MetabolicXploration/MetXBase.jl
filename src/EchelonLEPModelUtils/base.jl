import Base.show
# show(io::IO, elep::EchelonLEPModel) = (println(io, "EchelonLEPModel"); summary(io, elep))
show(io::IO, elep::EchelonLEPModel) = println(io, "EchelonLEPModel ", size(elep))

import Base.size
size(elep::EchelonLEPModel) = size(elep.lep)

import Base.hash
function hash(elep::EchelonLEPModel, h::UInt64 = UInt64(0)) 
    h += hash(:EchelonLEPModel)
    h = hash(elep.lep, h)
    h = hash(elep.G, h)
    return h
end
hash(elep::EchelonLEPModel, h::Integer) = hash(elep, UInt64(h)) 