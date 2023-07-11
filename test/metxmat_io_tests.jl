let

    println()
    println("="^60)
    println("METXMAT STUFF")
    println("."^60)
    println()

    test_dir = tempdir()
    mkpath(test_dir)
    mfile = joinpath(test_dir, "test.mat")

    try

        lep0 = toy_model(LEPModel)
        save_metxmat(lep0, mfile)
        lep1 = load_metxmat(LEPModel, mfile)
        @test lep0 == lep1

        # elep
        global elep0 = EchelonLEPModel(lep0; verbose = true)
        save_metxmat(elep0, mfile)
        elep1 = load_metxmat(EchelonLEPModel, mfile)
        @test elep0 == elep1
    
    finally
        rm(mfile; force = true)
    end

end