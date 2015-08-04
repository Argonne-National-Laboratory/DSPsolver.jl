# Julia interface for general decomposition modeling in DSP
# ctjandra - 2015 ANL MCS

type CouplingConstraints
	couplingConstraints::Vector{JuMP.LinearConstraint}
	varBlocks::Dict{JuMP.Variable, Int}
end

# Default constructor
function CouplingConstraints()
	return CouplingConstraints(JuMP.LinearConstraint[], (JuMP.Variable => Int)[]);
end

function loadDecomposition(m::JuMP.Model, cc::CouplingConstraints)
	# Check pointer to model
	check_problem();

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

	# Extract constraints to arrays
	constrs = cc.couplingConstraints;
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

	# Extract varBlocks to array
	varBlocksArray = zeros(Int, ncols);
	for (var, block) in cc.varBlocks
		varBlocksArray[startingCol[var.m] + var.col] = block;
	end
	for p in varBlocksArray
		if p <= 0
			println("Error: Variable without block found (identifiers must be positive)");
			exit();
		end
	end

	# Load coupling constraints into DSP
	@dsp_ccall("loadDecomposition", Void, (Ptr{Void}, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cchar}, Ptr{Cdouble}),
		env.p,
		convert(Cint, maximum(varBlocksArray)),
		convert(Cint, length(varBlocksArray)),
		convert(Cint, length(couplingStarts) - 1),          # last element of starts only indicates end
		convert(Vector{Cint}, varBlocksArray .- one(Int)), # adjust indices to start at zero
		convert(Vector{Cint}, couplingStarts .- one(Int)),  # adjust indices to start at zero
		convert(Vector{Cint}, couplingCols .- one(Int)),    # adjust indices to start at zero
		convert(Vector{Cdouble}, couplingCoeffs),
		convert(Vector{Cchar}, couplingSenses),
		convert(Vector{Cdouble}, couplingRhs))
end

function addCouplingConstraint(cc::CouplingConstraints, constr::JuMP.LinearConstraint)
	push!(cc.couplingConstraints, constr);
end

function addVarBlocks(cc::CouplingConstraints, varBlocks::Dict{JuMP.Variable, Int})
	cc.varBlocks = varBlocks;
end
