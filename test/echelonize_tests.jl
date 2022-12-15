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
    @time idxd = basis_rxns(S, b; tol = 1e-10)
    @show length(idxd)
    @test rank(S) == length(idxd)
    
    # echelonize
    @time idxf, idxd, idxmap, G, be = echelonize(S, b; tol = 1e-10)
    Nf = length(idxf)
    Nd = length(idxd)
    @show size(G)
    @test Nf + Nd == N
    @test all(sort(idxmap) .== collect(1:N))
    # @test rank(G) == Nf
    @test length(be) == rank(S)
    @test isempty(intersect(idxf, idxd))

    # net
    enet = EchelonMetNet(net0)
    net1 = metnet(enet)
    @show size(net1)
    # DONE: test FBA (see MetXOptim)
    @test rank(net0.S) == rank(net1.S)
    @test all(net1.b .== be)
    @test all(reactions(net1) .== reactions(net0))
    @test isapprox(net1.S[:, enet.idxd],  Matrix(I, Nd, Nd); atol = 1e-5)

    println()
end