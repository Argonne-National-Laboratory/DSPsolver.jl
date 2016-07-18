# DSPsolver

The DSPsolver.jl package provides an interface for using an open-source software package [DSP](https://github.com/kibaekkim/DSP) for solving stochastic mixed-integer programming problems from the [Julia](http://julialang.org) language. You need to download and install DSP package.

This package requires the StructJuMP.jl and MPI.jl packages for Julia. The [StructJuMP.jl](https://github.com/StructJuMP/StructJuMP.jl) package provides a scalable algebraic modeling tool for stochastic programming. The [MPI.jl](https://github.com/JuliaParallel/MPI.jl) package enables the Julia script to run on a distributed computing system via MPI communication.

## Installation
You can install DSPsolver.jl using the Julia package system.
```julia
Pkg.clone("https://github.com/Argonne-National-Laboratory/DSPsolver.jl");
```

## Example
The following example shows a Julia script that uses DSPsolver.jl for solving a two-stage stochastic integer programming problem.
```julia
using DSPsolver, StructJuMP, MPI; # Load packages

# Initialize MPI
MPI.Init();

# random parameter
xi = [[7,7] [11,11] [13,13]];

# StochJuMP.jl model scripts
m = StochasticModel(3);
@defVar(m, 0 <= x[i=1:2] <= 5, Int);
@setObjective(m, Min, -1.5*x[1]-4*x[2]);
@second_stage m s begin
	q = StochasticBlock(m, 1/3);
	@defVal(q, y[j=1:4], Bin);
	@setObjective(q, Min, -16*y[1]+19*y[2]+23*y[3]+28*y[4]);
	@addConstraint(q, 2*y[1]+3*y[2]+4*y[3]+5*y[4]<=xi[1,s]-x[1]);
	@addConstraint(q, 6*y[1]+1*y[2]+3*y[3]+2*y[4]<=xi[2,s]-x[2]);
end

DSPsolver.loadProblem(m);       # Load model m to DSP
DSPsolver.solve(DSP_SOLVER_DD); # Solve problem using dual decomposition

# print out upper/lower bounds
println("Upper Bound: ", DSPsolver.getPrimalBound());
println("Lower Bound: ", DSPsolver.getDualBound());

# Finalize MPI
MPI.Finalize();
```
