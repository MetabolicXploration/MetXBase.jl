import Base.show
show(io::IO, m::EchelonMetNet) = (println(io, "EchelonMetNet"); summary(io, m))