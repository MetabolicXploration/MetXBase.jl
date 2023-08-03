let

    println()
    println("="^60)
    println("TOOLS")
    println("."^60)
    println()

    # _find_nearest
    _v = 1:100
    @test MetXBase._find_nearest(10, _v) == 10
    _v = [1:100;] .+ 0.1
    @test MetXBase._find_nearest(10, _v) == 10

end