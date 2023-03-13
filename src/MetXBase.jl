# TODO: Use DocStringExtensions.jl (see BIGGReactions.jl as example)

# TODO: setup Quek2014-Recon2 network 
# Este es el paper: Quek2014 - Metabolic flux analysis of HEK cell culture using Recon 2 (reduced version of Recon 2)
# Download link: https://www.ebi.ac.uk/biomodels/MODEL1504080000

module MetXBase

    using SparseArrays
    using UnicodePlots
    using ProgressMeter
    using Statistics
    using LinearAlgebra
    using StringRepFilter
    
    import Printf: @sprintf

    #! include .

    #! include Types
    include("Types/0_AbstractLEPModels.jl")
    include("Types/1_LEPModels.jl")
    
    #! include Utils
    include("Utils/IterChunks.jl")
    include("Utils/TagDBs.jl")
    include("Utils/callback_utils.jl")
    include("Utils/echelonize.jl")
    include("Utils/echelonize2.jl")
    include("Utils/exportall.jl")
    include("Utils/extras_interface.jl")
    include("Utils/grad_desc.jl")
    include("Utils/iders_interface.jl")
    include("Utils/linear_fit.jl")
    include("Utils/mgrscho.jl")
    include("Utils/nearPD.jl")
    include("Utils/printing.jl")
    include("Utils/tools.jl")
    include("Utils/trunc_sample.jl")

    #! include LEPModelUtils
    include("LEPModelUtils/base.jl")
    include("LEPModelUtils/empty_fixxed.jl")
    include("LEPModelUtils/empty_interface.jl")
    include("LEPModelUtils/lep_interface.jl")
    include("LEPModelUtils/rand_lep.jl")
    include("LEPModelUtils/reindex.jl")
    include("LEPModelUtils/resize.jl")
    
    #! include AbstractLEPModelUtils
    include("AbstractLEPModelUtils/ider_interface.jl")
    include("AbstractLEPModelUtils/lep_interface.jl")
    
    @_exportall_underscore
    @_exportall_uppercase

end