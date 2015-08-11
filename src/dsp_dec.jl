# Julia interface for general decomposition modeling in DSP
# ctjandra - 2015 ANL MCS

type CouplingConstraints
	couplingConstraints::Vector{JuMP.LinearConstraint}
	varSubproblems::Dict{JuMP.Variable, Int}
end

# Default constructor
function CouplingConstraints()
	return CouplingConstraints(JuMP.LinearConstraint[], (JuMP.Variable => Int)[]);
end

# No need to load this explicitly, should be called by loadProblem
function loadDecomposition(m::JuMP.Model)
	# Check pointer to model
	check_problem();

	if !haskey(m.ext, :DSP_Decomposition)
		error("No decomposition to load");
	end

	# Map from Model to the first column of the model in extensive form
	startingCol = (JuMP.Model => Int)[];
 	startingCol[m] = 0;
 	ncols = m.numCols;
	if haskey(m.ext, :Stochastic)
		for sb in StochJuMP.getchildren(m)
			startingCol[sb] = ncols;
			ncols += sb.numCols;
		end
	end

	cc = m.ext[:DSP_Decomposition]

	constrs = cc.couplingConstraints
	if length(constrs) == 0
		error("General decomposition incomplete: Variables were set to subproblems, but no coupling constraints were specified");
	end

	# Convert constraints to arrays
	couplingStarts = Int[];
	couplingCols = Int[];
	couplingCoeffs = Float64[];
	couplingSenses = Char[];
	couplingRhs = Float64[];
	nextStart = 1;
	push!(couplingStarts, nextStart);
	for c in 1:length(constrs)
		# Add constraint to arrays
		for var in constrs[c].terms.vars
			push!(couplingCols, startingCol[var.m] + var.col);
		end
		append!(couplingCoeffs, constrs[c].terms.coeffs);
		nextStart += length(constrs[c].terms.coeffs);
		push!(couplingStarts, nextStart);

		@assert constrs[c].lb != -Inf || constrs[c].ub != Inf
		if constrs[c].ub == constrs[c].lb
			push!(couplingSenses, 'E');
			push!(couplingRhs, constrs[c].ub);
		elseif constrs[c].lb == -Inf
			push!(couplingSenses, 'L');
			push!(couplingRhs, constrs[c].ub);
		else
			push!(couplingSenses, 'G');
			push!(couplingRhs, constrs[c].lb);

			if constrs[c].ub != Inf
				# Range constraint: add the other bound
				for var in constrs[c].terms.vars
					push!(couplingCols, startingCol[var.m] + var.col);
				end
				append!(couplingCoeffs, constrs[c].terms.coeffs);
				nextStart += length(constrs[c].terms.coeffs);
				push!(couplingStarts, nextStart);
				push!(couplingSenses, 'L');
				push!(couplingRhs, constrs[c].ub);
			end
		end
	end

	# Extract varSubproblems to array
	varSubproblemsArray = zeros(Int, ncols);
	for (var, block) in cc.varSubproblems
		varSubproblemsArray[startingCol[var.m] + var.col] = block;
	end
	for p in varSubproblemsArray
		if p <= 0
			error("General decomposition incomplete: Variable was not set to a subproblem (identifiers must be positive)");
		end
	end

	# Load coupling constraints into DSP
	@dsp_ccall("loadDecomposition", Void, (Ptr{Void}, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cchar}, Ptr{Cdouble}),
		env.p,
		convert(Cint, maximum(varSubproblemsArray)),
		convert(Cint, length(varSubproblemsArray)),
		convert(Cint, length(couplingStarts) - 1),          # last element of starts only indicates end
		convert(Vector{Cint}, varSubproblemsArray .- one(Int)), # adjust indices to start at zero
		convert(Vector{Cint}, couplingStarts .- one(Int)),  # adjust indices to start at zero
		convert(Vector{Cint}, couplingCols .- one(Int)),    # adjust indices to start at zero
		convert(Vector{Cdouble}, couplingCoeffs),
		convert(Vector{Cchar}, couplingSenses),
		convert(Vector{Cdouble}, couplingRhs))
end

function initDecomposition(m::JuMP.Model)
	if haskey(m.ext, :DSP_Decomposition)
		return
	end
	m.ext[:DSP_Decomposition] = CouplingConstraints();
end


## External functions

function addCouplingConstraint(m::JuMP.Model, constr::JuMP.LinearConstraint)
	mod = m;
	# It does not matter whether m is the parent model or a stochastic block (child); all info is added to parent
	while haskey(mod.ext, :Stochastic) && StochJuMP.getparent(mod) != nothing
		mod = StochJuMP.getparent(mod);
	end

	initDecomposition(mod);
	push!(mod.ext[:DSP_Decomposition].couplingConstraints, constr);
end

function setVarSubproblem(m::JuMP.Model, var::JuMP.Variable, subproblem::Integer)
	mod = m;
	while haskey(mod.ext, :Stochastic) && StochJuMP.getparent(mod) != nothing
		mod = StochJuMP.getparent(mod);
	end

	initDecomposition(mod);
	mod.ext[:DSP_Decomposition].varSubproblems[var] = subproblem;
end
