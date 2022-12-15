# TODO: make an automatic dim relation check system (Not only for MetNets but other structs)

# Check if all fields dims are consistent
function check_dims(net)
    
    M, N = size(net)
    for (expected_len, field) in [
            (N, :lb), (N, :ub), (M, :b), 
            (N, :c), (M, :mets), (N, :rxns)
        ]
        dat = getfield(net, field)
        dat_len = length(dat)
        expected_len != dat_len && 
            error("'$(field)' len = $(dat_len) missmatch net size = $(size(net))")
    end
end
