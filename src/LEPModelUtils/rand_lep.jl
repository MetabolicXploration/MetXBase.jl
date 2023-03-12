## ----------------------------------------------------
function _rand_lep(M, N)
    S = rand(M, N)
    b = rand(M)
    lb = zeros(N)
    ub = ones(N)
    c = zeros(N)
    C = nothing
    rowids = ["M$i" for i in 1:M]
    colids = ["N$i" for i in 1:N]
    return LEPModel(S, b, lb, ub, c, C, rowids, colids, Dict()) 
end
