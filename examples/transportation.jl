using StochJuMP, DSPsolver

MPI.Init()

m = StochasticModel(3)

factories = 1:3
centers = 1:5
scenarios = ["lo", "mid", "hi"]

cap = [500, 450, 650]

demand = [150 160 170;
          100 120 135;
          250 270 300;
          300 325 350;
          600 700 800]

prob = [0.25, 0.5, 0.25]

transcost = [2.49 5.21 3.76 4.85 2.07;
             1.46 2.54 1.83 1.86 4.76;
             3.26 3.08 2.60 3.76 4.45]

prodcost = 14
price = 24
wastecost = 4

@defVar(m, ship[factories,centers] >= 0)
@defVar(m, product[factories] >= 0)
@defVar(m, sales[centers] >= 0)
@defVar(m, waste[centers] >= 0)
@defVar(m, profit)

@defVar(m, received[centers] >= 0)
@setObjective(m, Min, sum{transcost[i,j]*ship[i,j], i=factories, j=centers} + sum{prodcost*product[i], i=factories})
for j in centers
    @addConstraint(m, received[j] == sum{ship[i,j], i=factories})
end
for i in factories
    @addConstraint(m, product[i] == sum{ship[i,j], j=centers})
end

for (s, elem) in enumerate(scenarios)
    bl = StochasticBlock(m, s)
    @defVar(bl, 0 <= salesw[i=centers] <= demand[i,s])
    @defVar(bl, wastew[centers] >= 0)
    @setObjective(bl, Min, -sum{price*prob[s]*salesw[j], j=centers} + sum{wastecost*prob[s]*wastew[j], j=centers})
    for j in centers
        @addConstraint(bl, received[j] == salesw[j]+wastew[j])
    end
end

DSPsolver.setLogLevel(2)
DSPsolver.loadProblem(m)
DSPsolver.solve()
