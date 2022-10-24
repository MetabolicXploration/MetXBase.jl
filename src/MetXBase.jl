# TODO: Use DocStringExtensions.jl (see BIGGReactions.jl as example)

module MetXBase

    using SparseArrays
    
    import COBREXA
    
    export MetNet


    #! include .

    #! include Types
    include("Types/MetNets.jl")
    
    #! include Utils
    include("Utils/extras_interface.jl")
    include("Utils/iders_interface.jl")
    include("Utils/net_interface.jl")
    include("Utils/printing.jl")
    
    #! include MetNetUtils
    include("MetNetUtils/balance_str.jl")
    include("MetNetUtils/base.jl")
    include("MetNetUtils/check_dims.jl")
    include("MetNetUtils/convert.jl")
    include("MetNetUtils/getter.jl")
    include("MetNetUtils/interfaces.jl")
    include("MetNetUtils/search.jl")
    include("MetNetUtils/setter.jl")
    
    #! include IO
    include("IO/load_net.jl")
    

end