lepmodel(elep::EchelonLEPModel) = elep.lep

rowids(elep::EchelonLEPModel) = elep.lep.rowids
colids(elep::EchelonLEPModel) = elep.lep.colids

# independent/dependent
icolids(elep::EchelonLEPModel) = colids(elep.lep, elep.idxi)
dcolids(elep::EchelonLEPModel) = colids(elep.lep, elep.idxd)