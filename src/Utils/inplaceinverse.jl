# Code derived from metabolicEP (https://github.com/anna-pa-m/Metabolic-EP)

# TODO: Move to MetXBase
function inplaceinverse!(dest::AbstractArray, source::AbstractArray; δ = 1e-10)
    copyto!(dest, source)
    try
        inv!(cholesky!(Hermitian(dest)))
    catch err
        if err isa PosDefException
            nearPD!(dest, δ)
            # @show isposdef(dest)
            inv!(cholesky!(Hermitian(dest)))
            return nothing
        end
        rethrow(err)
    end
    return nothing
end