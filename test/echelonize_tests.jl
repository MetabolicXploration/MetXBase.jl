let

    println()
    println("="^60)
    println("ECHELONIZE")
    println("."^60)
    println()


    net0 = MetXNetHub.pull_net("ecoli_core")
    biom_ider = extras(net0, "BIOM")
    glc_ider = extras(net0, "EX_GLC")
    S = net0.S
    b = net0.b
    M, N = size(S)
    @show size(net0)

    # indep_rxns
    @time idxind = indep_rxns(S; eps = 1e-10)
    @show length(idxind)
    @test rank(S) == length(idxind)
    
    # echelonize
    @time idxind, idxdep, idxmap, IG, bnew = echelonize(S, b; eps = 1e-10)
    Ni = length(idxind)
    Nd = length(idxdep)
    @show size(IG)
    @test Ni + Nd == N
    @test Ni == rank(S)
    @test rank(IG) == rank(S)
    @test length(bnew) == rank(S)
    @test isempty(intersect(idxind, idxdep))
    @test isapprox(IG[:,1:Ni], I; atol = 1e-10)

    # net
    net1 = echelonize(net0)
    @show size(net1)

    @test all(net1.S .== IG)
    @test all(net1.b .== bnew)
    @test all(reactions(net1) .== reactions(net0, idxmap))

    println()
end