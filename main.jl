using GLPK

⊕(cost_matrix::Matrix{Int64}, B::Matrix{Int64})::Int64 = sum(cost_matrix[1:end-1, 1:end-1] .* B[1:end-1, 1:end-1])


cost(A::Matrix{Int64}, B::Matrix{Int64})::Int64 = A ⊕ B

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

function find_initial_solution(A::Matrix{Int64}, debug::Bool=false)
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

function decomposition(A::Matrix{Int64}, B::Matrix{Int64}, debug::Bool=false)::Tuple{Vector{Float64},Vector{Float64}}
    n, m = size(A)
    u, v = zeros(n), zeros(m)
    # initialiser le modèle d'optimisation
    model = Model(GLPK.Optimizer)
    # définir les variables de décision
    @variable(model, u[1:n])
    @variable(model, v[1:m])
    # définir la contrainte initiale u[1] = 0
    @constraint(model, u[1] == 0)
    # définir les contraintes
    for i in 1:n
        for j in 1:m
            if B[i, j] != 0
                @constraint(model, C[i, j] == u[i] + v[j])
            end
        end
    end
    optimize!(model)
    debug && println("u = ", value.(u))
    debug && println("v = ", value.(v))
    value.(u), value.(v)
end

function rate(A::Matrix{Int64}, u::Vector{Float64}, v::Vector{Float64}, debug::Bool=false)::Matrix{Int64}
    n, m = size(A)
    rate_matrix::Matrix{Int64} = zeros(n, m)
    for i in 1:n
        for j in 1:m
            if A[i, j] == 0
                rate_matrix[i, j] = A[i, j] - (u[i] + v[j])
            end
        end
    end
    return rate_matrix
end
function main()

    C::Matrix{Int64} = [
        147 121 344 552 450
        241 153 102 312 450
        451 364 557 285 750
        400 450 550 250 1650
    ]
    # algorithm(A, true)
    B = find_initial_solution(C, true)
    @show decomposition(C[1:end-1, 1:end-1], B[1:end-1, 1:end-1], true)
end

main()