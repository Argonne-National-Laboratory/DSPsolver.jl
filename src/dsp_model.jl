function readSmps(filename)
	# Check pointer to TssModel
	check_problem()
	@dsp_ccall("readSmps", Void, (Ptr{Void}, Ptr{Uint8}), env.p, convert(Vector{Uint8}, filename))
end

function loadProblem(model::JuMP.Model)
	# Check pointer to TssModel
	check_problem()
	# get scenario problem
	stoch = StochJuMP.getStochastic(model)
	
	nscen  = convert(Cint, stoch.num_scen)
	ncols1 = convert(Cint, model.numCols)
	nrows1 = convert(Cint, length(model.linconstr))
	ncols2 = 0
	nrows2 = 0
	proc_idx_set = 1:nscen;
	if isdefined(:MPI) == true
		proc_idx_set = StochJuMP.getProcIdxSet(model);
	end
	setDdProcIdxSet(proc_idx_set);  
	for s in 1:length(proc_idx_set)
		ncols2 = convert(Cint, stoch.children[s].numCols)
		nrows2 = convert(Cint, length(stoch.children[s].linconstr))
		break;
	end
	
	@dsp_ccall("setNumberOfScenarios", Void, (Ptr{Void}, Cint), env.p, nscen)
	@dsp_ccall("setDimensions", Void, 
		(Ptr{Void}, Cint, Cint, Cint, Cint), 
		env.p, ncols1, nrows1, ncols2, nrows2)
	
	# get problem data
	start, index, value, clbd, cubd, ctype, obj, rlbd, rubd = getDataFormat(model)
	
	@dsp_ccall("loadFirstStage", Void, 
		(Ptr{Void}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Uint8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
		env.p, start, index, value, clbd, cubd, ctype, obj, rlbd, rubd)
	
	for s in 1:length(proc_idx_set)
		# get model
		sb = stoch.children[s]
		probability = stoch.probability[s]
		# get model data
		start, index, value, clbd, cubd, ctype, obj, rlbd, rubd = getDataFormat(sb)
		@dsp_ccall("loadSecondStage", Void, 
			(Ptr{Void}, Cint, Cdouble, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Uint8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), 
			env.p, proc_idx_set[s]-1, probability, start, index, value, clbd, cubd, ctype, obj, rlbd, rubd)
	end
	
end


function freeModel()
	check_problem(env)
	@dsp_ccall("freeTssModel", Void, (Ptr{Void},), env.p)
end

