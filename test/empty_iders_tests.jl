let
    println()
    println("="^60)
    println("EMPTY STUFF")
    println("."^60)
    println()

    net = MetXNetHub.pull_net("iJR904")
    # summary(net)
    size0 = size(net)
    dels0 = (isempty.(metabolites(net)), isempty.(reactions(net))) .|> count
    
    # fix stuff
    idxs = 5:50
    net.lb[idxs] .= net.ub[idxs] .= 1.0
    
    empty_fixxed!(net)  
    summary(net)
    dels1 = (isempty.(metabolites(net)), isempty.(reactions(net))) .|> count
    
    @test all(dels1 .>= dels0)
    @test all(dels1 .>= (0, length(idxs)))
    
    net = emptyless_model(net)
    dels2 = (isempty.(metabolites(net)), isempty.(reactions(net))) .|> count
    summary(net)

    @test all(iszero.(dels2))

    println()
end