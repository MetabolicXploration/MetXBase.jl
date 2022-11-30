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

    # basis_rxns
    @time idxdep = basis_rxns(S, b; tol = 1e-10)
    @show length(idxdep)
    @test rank(S) == length(idxdep)
    
    # echelonize
    @time idxind, idxdep, idxmap, G, bnew = echelonize(S, b; tol = 1e-10)
    Ni = length(idxind)
    Nd = length(idxdep)
    @show size(G)
    @test Ni + Nd == N
    @test all(sort(idxmap) .== collect(1:N))
    # TODO: check if G needs to be full ranked
    # @test rank(G) == Ni
    @test length(bnew) == rank(S)
    @test isempty(intersect(idxind, idxdep))

    # net
    net1 = EchelonMetNet(net0)
    @show size(net1)
    # TODO: test FBA
    @test rank(net0.S) == rank(net1.S)
    @test all(net1.b .== bnew)
    @test all(reactions(net1) .== reactions(net0, idxmap))
    @test sum(net.S[:, enet.idxd] .== 1.0) .== length(enet.idxd)

    println()
end