function test_iders()
    net = MetXBase.toy_model()

    for (i, rxn) in enumerate(reactions(net))
        @test rxnindex(net, i) == i
        @test rxnindex(net, rxn) == i
    end

    for (i, met) in enumerate(metabolites(net))
        @test metindex(net, i) == i
        @test metindex(net, met) == i
    end

    @test_throws ErrorException metindex(net, "met_not_in_model")
    @test_throws ErrorException rxnindex(net, "rxn_not_in_model")

end
test_iders()