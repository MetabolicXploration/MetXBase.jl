# TODO: Use DocStringExtensions.jl (see BIGGReactions.jl as example)

module MetXBase

    using SparseArrays
    using Serialization
    using UnicodePlots
    using ProgressMeter
    using Statistics
    using LinearAlgebra
    
    import COBREXA
    import Printf: @sprintf

    
    export MetNet


    #! include .

    #! include Types
    include("Types/0_AbstractMetNets.jl")
    include("Types/1_MetNets.jl")
    include("Types/2_EchelonMetNet.jl")
    
    #! include Utils
    include("Utils/IterChunks.jl")
    include("Utils/callback_utils.jl")
    include("Utils/echelonize.jl")
    include("Utils/echelonize2.jl")
    include("Utils/extras_interface.jl")
    include("Utils/grad_desc.jl")
    include("Utils/iders_interface.jl")
    include("Utils/mgrscho.jl")
    include("Utils/nearPD.jl")
    include("Utils/net_interface.jl")
    include("Utils/printing.jl")
    include("Utils/tools.jl")
    include("Utils/toy_model.jl")
    
    #! include MetNetUtils
    include("MetNetUtils/balance_str.jl")
    include("MetNetUtils/base.jl")
    include("MetNetUtils/check_dims.jl")
    include("MetNetUtils/convert.jl")
    include("MetNetUtils/echelonize.jl")
    include("MetNetUtils/empty_stuf.jl")
    include("MetNetUtils/fixxed_reduction.jl")
    include("MetNetUtils/getter.jl")
    include("MetNetUtils/interfaces.jl")
    include("MetNetUtils/queries.jl")
    include("MetNetUtils/reindex.jl")
    include("MetNetUtils/rxn_str.jl")
    include("MetNetUtils/search.jl")
    include("MetNetUtils/setter.jl")
    include("MetNetUtils/summary.jl")
    
    
    #! include EchelonMetNetUtils
    include("EchelonMetNetUtils/net_interface.jl")

    #! include IO
    include("IO/load_net.jl")
    

end