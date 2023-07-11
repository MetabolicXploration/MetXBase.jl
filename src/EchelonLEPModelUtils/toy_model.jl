function toy_model(::Type{EchelonLEPModel})
    lep = toy_model(LEPModel)
    return EchelonLEPModel(lep)
end