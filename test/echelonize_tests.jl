let

    Random.seed!(10)

    println()
    println("="^60)
    println("ECHELONIZE")
    println("."^60)
    println()

    net0 = _rand_lep(5, 10)
    S = net0.S
    b = net0.b
    M, N = size(S)
    @show size(net0)

    # basis_rxns
    @time idxd = basis_rxns(S, b; tol = 1e-10)
    @show length(idxd)
    @show rank(S)
    @test rank(S) == length(idxd)
    
    # echelonize
    @time idxf, idxd, idxmap, G, be = echelonize(S, b; tol = 1e-10)
    Nf = length(idxf)
    Nd = length(idxd)
    @show size(G)
    @test Nf + Nd == N
    @test all(sort(idxmap) .== collect(1:N))
    @test length(be) == rank(S)
    @test isempty(intersect(idxf, idxd))

    println()
end