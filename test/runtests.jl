using RunTestsEnv
@activate_testenv

using MetXBase
using MetXNetHub
using Test
using LinearAlgebra

import Random
Random.seed!(1234)

@testset "MetXBase.jl" begin

    # Utils
    include("IterChunks_tests.jl")
    include("echelonize_tests.jl")
    include("grad_desc_tests.jl")
    include("TagDB_tests.jl")
    
    # MetNet
    include("getters_tests.jl")
    include("iders_tests.jl")
    include("net_manipulation_tests.jl")

    # TODO: Test convert COBREXA --> MetXNet


end
