using MetXBase
using Test
using LinearAlgebra
using Base.Threads

import Random
Random.seed!(1234)

@testset "MetXBase.jl" begin

    # Utils
    include("tools_tests.jl")
    include("IterChunks_tests.jl")
    include("manipulation_tests.jl")
    include("echelonize_tests.jl")
    include("grad_desc_tests.jl")
    include("TagDB_tests.jl")
    include("metxmat_io_tests.jl")


end
