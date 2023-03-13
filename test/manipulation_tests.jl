let
    println()
    println("="^60)
    println("NET MANIPULATION")
    println("."^60)
    println()

    # ---------------------------------------------------------------
    # Empty stuff
    lep = _rand_lep(60, 100)
    lep.b .= 0.0
    size0 = size(lep)
    dels0 = (isempty.(rowids(lep)), isempty.(colids(lep))) .|> count
    
    # fix stuff
    idxs = 5:50
    lep.lb[idxs] .= lep.ub[idxs] .= 1.0
    
    empty_fixxed!(lep)  
    summary(lep)
    dels1 = (isempty.(rowids(lep)), isempty.(colids(lep))) .|> count
    
    @test all(dels1 .>= dels0)
    @test all(dels1 .>= (0, length(idxs)))
    
    lep = emptyless_model(lep)
    dels2 = (isempty.(rowids(lep)), isempty.(colids(lep))) .|> count
    summary(lep)

    @test all(iszero.(dels2))

    # ---------------------------------------------------------------
    # reindex
    lep0 = _rand_lep(60, 100)
    lep1 = reindex(lep0, Colon(), reverse(lep0.colids))
    @test all(lep0.colids .== reverse(lep1.colids))
    lep2 = reindex(lep0, Colon(), lep0.colids)
    @test all(lep0.S .== lep2.S)

    println()
end