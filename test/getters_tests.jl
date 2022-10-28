let
    println()
    println("="^60)
    println("GETTER TEST")
    println("."^60)
    println()


    net = MetXBase.toy_model()
    @test metabolites(net) == net.mets
    @test reactions(net) == net.rxns

    for (i, rxn) in enumerate(reactions(net))
        @test ub(net, rxn) == net.ub[i]
        @test ub(net, i) == net.ub[i]
        @test lb(net, rxn) == net.lb[i]
        @test lb(net, i) == net.lb[i]
        @test reactions(net, i) == net.rxns[i]
        @test reactions(net, rxn) == rxn
    end

    for (i, met) in enumerate(metabolites(net))
        @test metabolites(net, i) == net.mets[i]
        @test metabolites(net, met) == net.mets[i]
    end

    println()
end