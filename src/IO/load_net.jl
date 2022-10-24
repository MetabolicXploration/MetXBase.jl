function load_net(mfile::AbstractString)
    
    cobxa_model = COBREXA.load_model(COBREXA.StandardModel, mfile)
    return convert(MetNet, cobxa_model)

end