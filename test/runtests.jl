using RunTestsEnv
@activate_testenv

using MetXBase
using MetXNetHub
using Test

import Random
Random.seed!(1234)

@testset "MetXBase.jl" begin

    # Utils†
    include("IterChunks_tests.jl")
    include("grad_desc_tests.jl")
    
    # MetNet
    include("getters_tests.jl")
    include("iders_tests.jl")
    include("empty_iders.jl")

    # TODO: Test convert COBREXA --> MetXNet


end
