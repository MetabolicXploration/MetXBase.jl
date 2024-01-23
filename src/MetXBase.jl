# TODO: Use DocStringExtensions.jl (see BIGGReactions.jl as example)

# TODO: setup Quek2014-Recon2 network 
# Este es el paper: Quek2014 - Metabolic flux analysis of HEK cell culture using Recon 2 (reduced version of Recon 2)
# Download link: https://www.ebi.ac.uk/biomodels/MODEL1504080000

# DONE: MetNet will be only for operation with the non LEPModel fields
# That is, right now, for nothing else than io and discovery tooling (search, summary, etc)
# MetXOptim must no depends on MetXGEMs even if the test env has it for MetXNetHub stuf
# A similar pattern for MetXEP MetXGrids MetXMC

# TODO: Add Graphs.jl kind of functionality for getting basic stuff

module MetXBase

    using SparseArrays
    using UnicodePlots
    using ProgressMeter
    using Statistics
    using LinearAlgebra
    using LinearAlgebra: inv!
    using StringRepFilter
    using Base.Threads
    
    import Printf: @sprintf
    import SpecialFunctions: erf
    import MAT

    #! include .

    #! include Types
    include("Types/0_AbstractLEPModels.jl")
    include("Types/1_LEPModels.jl")
    include("Types/2_EchelonLEPModel.jl")
    
    #! include Utils
    include("Utils/Histograms.jl")
    include("Utils/IterChunks.jl")
    include("Utils/TagDBs.jl")
    include("Utils/callback_utils.jl")
    include("Utils/distributions.jl")
    include("Utils/echelonize.jl")
    include("Utils/echelonize2.jl")
    include("Utils/exportall.jl")
    include("Utils/extras_interface.jl")
    include("Utils/grad_desc.jl")
    include("Utils/iders_interface.jl")
    include("Utils/inplaceinverse.jl")
    include("Utils/linear_fit.jl")
    include("Utils/metxmat_io.jl")
    include("Utils/mgrscho.jl")
    include("Utils/nearPD.jl")
    include("Utils/printing.jl")
    include("Utils/search.jl")
    include("Utils/tools.jl")
    include("Utils/trunc_sample.jl")

    #! include LEPModelUtils
    include("LEPModelUtils/base.jl")
    include("LEPModelUtils/cons_str.jl")
    include("LEPModelUtils/echelonize.jl")
    include("LEPModelUtils/empty_fixxed.jl")
    include("LEPModelUtils/empty_interface.jl")
    include("LEPModelUtils/lep_interface.jl")
    include("LEPModelUtils/metxmat_io.jl")
    include("LEPModelUtils/queries.jl")
    include("LEPModelUtils/rand_lep.jl")
    include("LEPModelUtils/reindex.jl")
    include("LEPModelUtils/resize.jl")
    include("LEPModelUtils/set_constraint.jl")
    include("LEPModelUtils/toy_model.jl")
    
    #! include AbstractLEPModelUtils
    include("AbstractLEPModelUtils/base.jl")
    include("AbstractLEPModelUtils/extras_interface.jl")
    include("AbstractLEPModelUtils/ider_interface.jl")
    include("AbstractLEPModelUtils/lep_interface.jl")
    include("AbstractLEPModelUtils/posdef.jl")
    
    #! include EchelonLEPModelUtils
    include("EchelonLEPModelUtils/base.jl")
    include("EchelonLEPModelUtils/lep_interface.jl")
    include("EchelonLEPModelUtils/metxmat_io.jl")
    include("EchelonLEPModelUtils/span.jl")
    include("EchelonLEPModelUtils/summary.jl")
    include("EchelonLEPModelUtils/toy_model.jl")
    
    @_exportall_underscore()
    @_exportall_non_underscore()

end