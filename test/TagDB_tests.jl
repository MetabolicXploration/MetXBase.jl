let
    db = TagDB()

    for i in 1:10, j in 20:30
        push!(db, "A", :I => i, :J => j; val = rand())
        push!(db, "B", :I => i, :J => j; val = rand())
    end
    
    r0 = query(db, "A", :I => 1:3, :J => 20; extract = "val")

    r1 = query(db, "A", 1:3, 20; extract = "val")
    @test all(r0 .== r1)
    r1 = query(db, 1:3, 20, "A"; extract = "val")
    @test all(r0 .== r1)
    r1 = query(db, [1,2,3], :J => 20, "A"; extract = "val")
    @test all(r0 .== r1)
    r1 = query(db, [3, 2, 1], 20, "A"; extract = "val")
    @test all(r0 .== reverse(r1))
    r1 = query(db, [3, 2, 1], 20, 'A'; extract = "val")
    @test all(r0 .== reverse(r1))
    r1 = query(db, [3, 2, 1], 20, ['A']; extract = "val")
    @test all(r0 .== reverse(r1))
    r1 = query(db, [3, 2, 1], 20, isequal("A"); extract = "val")
    @test all(r0 .== reverse(r1))
    
    r0 = query(db, "B", :I => 1:3, :J => isequal(30); extract = "val")
    
    r1 = query(Float64, db, "B", :I => 1:3, :J => 30; extract = "val")
    @test all(r0 .== r1)

end