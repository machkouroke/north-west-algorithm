function next(B::Matrix{Int64},
    d::Tuple{Int64,Int64},
    n::Int64,
    m::Int64,
    debug::Bool=false
)::Tuple{Int64,Tuple{Int64,Int64}}
    min_value::Int64 = min(B[n, d[2]], B[d[1], m])
    max_index::Tuple{Int64,Int64} = min_value == B[n, d[2]] ? (d[1], m) : (n, d[2])
    debug && println("max_index = $max_index")
    next_index = max_index == (d[1], m) ? (d[1], d[2] + 1) : (d[1] + 1, d[2])
    min_value, next_index
end

function algorithm(A::Matrix{Int64}, debug::Bool=false)
    n, m = size(A)
    B::Matrix{Int64} = zeros(n, m)
    B[end, 1:end] = A[end, 1:end]
    B[1:end, end] = A[1:end, end]
    d::Tuple{Int64,Int64} = (1, 1)
    debug && println("Démarrage de l'algorithme, valeur initiale de d = $d")
    debug && display(B)
    while true
        min_value, next_index = next(B, d, n, m, debug)
        debug && println("min_value = $min_value, next_index = $next_index")
        B[d...] = min_value
        ind = [[n, d[2]], [d[1], m]]
        B[CartesianIndex.(Tuple.(ind))] .-= min_value
        d = next_index
        debug && println("d = $d")
        debug && display(B)
        d == (n, m) && break
    end
    debug && display(B)
    return B
end

⊕(cost_matrix::Matrix{Int64}, B::Matrix{Int64})::Int64 = sum(cost_matrix[1:end-1, 1:end-1] .* B[1:end-1, 1:end-1])

function main()
    A::Matrix{Int64} = [
        10 14 8 20
        12 15 10 30
        22 32 16 40
        40 30 20 90
    ]
    A ⊕ algorithm(A, true) 
end

main()