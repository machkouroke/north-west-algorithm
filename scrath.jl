using GLPK

# définir les données du problème
n = 3
m = 4
u = zeros(n)
v = zeros(m)
B = [
    400   50    0    0     
    0  400   50    0     
    0    0  500  250     
]
C = [
    147 121 344 552 
    241 153 102 312
    451 364 557 285 
]

# initialiser le modèle d'optimisation
model = Model(GLPK.Optimizer)

# définir les variables de décision
@variable(model, u[1:n])
@variable(model, v[1:m])

# définir la fonction objectif
@constraint(model, u[1] == 0)

# définir les contraintes
for i in 1:n
    for j in 1:m
        if B[i,j] != 0
            @constraint(model, C[i,j] == u[i]+v[j])
        end
    end
end

# résoudre le modèle
optimize!(model)

# afficher les résultats
println("u = ", value.(u))
println("v = ", value.(v))
println("Minimum de la fonction objectif = ", objective_value(model))


