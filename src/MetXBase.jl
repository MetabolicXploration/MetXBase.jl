# TODO: Use DocStringExtensions.jl (see BIGGReactions.jl as example)

# TODO: setup Quek2014-Recon2 network 
# Este es el paper: Quek2014 - Metabolic flux analysis of HEK cell culture using Recon 2 (reduced version of Recon 2)
# Download link: https://www.ebi.ac.uk/biomodels/MODEL1504080000

module MetXBase

    using SparseArrays
    using Serialization
    using UnicodePlots
    using ProgressMeter
    using Statistics
    using LinearAlgebra
    using StringRepFilter
    
    import COBREXA
    import Printf: @sprintf

    #! include .

    #! include Types
    include("Types/0_AbstractMetNets.jl")
    include("Types/1_MetNets.jl")
    include("Types/2_EchelonMetNet.jl")
    
    #! include Utils
    include("Utils/IterChunks.jl")
    include("Utils/TagDBs.jl")
    include("Utils/callback_utils.jl")
    include("Utils/connectome.jl")
    include("Utils/echelonize.jl")
    include("Utils/echelonize2.jl")
    include("Utils/exportall.jl")
    include("Utils/extras_interface.jl")
    include("Utils/grad_desc.jl")
    include("Utils/iders_interface.jl")
    include("Utils/linear_fit.jl")
    include("Utils/mgrscho.jl")
    include("Utils/nearPD.jl")
    include("Utils/net_interface.jl")
    include("Utils/printing.jl")
    include("Utils/tools.jl")
    include("Utils/toy_model.jl")
    include("Utils/trunc_sample.jl")
    
    #! include MetNetUtils
    include("MetNetUtils/balance_str.jl")
    include("MetNetUtils/base.jl")
    include("MetNetUtils/boundutils.jl")
    include("MetNetUtils/check_dims.jl")
    include("MetNetUtils/convert.jl")
    include("MetNetUtils/echelonize.jl")
    include("MetNetUtils/empty_stuf.jl")
    include("MetNetUtils/fixxed_reduction.jl")
    include("MetNetUtils/getter.jl")
    include("MetNetUtils/interfaces.jl")
    include("MetNetUtils/queries.jl")
    include("MetNetUtils/reindex.jl")
    include("MetNetUtils/resize.jl")
    include("MetNetUtils/rxn_str.jl")
    include("MetNetUtils/search.jl")
    include("MetNetUtils/setter.jl")
    include("MetNetUtils/summary.jl")
    
    #! include EchelonMetNetUtils
    include("EchelonMetNetUtils/base.jl")
    include("EchelonMetNetUtils/net_interface.jl")
    include("EchelonMetNetUtils/span.jl")
    include("EchelonMetNetUtils/summary.jl")

    #! include IO
    include("IO/load_net.jl")
    
    @_exportall_underscore
    @_exportall_uppercase

end