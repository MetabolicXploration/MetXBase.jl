function toy_model(::Type{LEPModel})
    net = Dict()
    net[:S] = 
    # rxns: gt    ferm  resp  ldh   lt   biom    atpm  # mets
        [   1.0  -1.0   0.0   0.0   0.0   0.0    0.0;  #  G
            0.0   2.0  18.0   0.0   0.0  -55.0  -5.0;  #  E
            0.0   2.0  -1.0  -1.0   0.0   0.0    0.0;  #  P
            0.0   0.0   0.0   1.0   1.0   0.0    0.0;  #  L
        ]
    
    net[:rowids] = ["G", "E", "P", "L"]
    net[:b] =    [0.0, 0.0, 0.0, 0.0] 
    
    net[:colids] = ["gt"  ,"ferm" ,"resp" , "ldh" ,  "lt" , "biom", "atpm"];
    net[:lb] =   [0.0   , 0.0   , 0.0   ,  0.0  , -100.0,   0.0,     0.5];
    net[:ub] =   [10.0 , 100.0 , 100.0 , 100.0 ,    0.0, 100.0,    100.0];
    net[:c] =    [ 0.0 ,   0.0 ,   0.0 ,   0.0 ,    0.0,   1.0,      0.0];
    
    return LEPModel(;net...)
end

