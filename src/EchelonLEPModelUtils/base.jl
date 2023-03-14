import Base.show
# show(io::IO, m::EchelonLEPModel) = (println(io, "EchelonLEPModel"); summary(io, m))
show(io::IO, m::EchelonLEPModel) = println(io, "EchelonLEPModel ", size(m))