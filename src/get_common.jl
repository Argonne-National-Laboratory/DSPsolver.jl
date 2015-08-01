function getDataFormat(model::JuMP.Model)
	# Get a column-wise sparse matrix
	mat = prepConstrMatrix(model)
	
	# Tranpose; now I have row-wise sparse matrix
	mat = mat'
	
	# sparse description
	start = convert(Vector{Cint}, mat.colptr - 1)
	index = convert(Vector{Cint}, mat.rowval - 1)
	value = mat.nzval
	
	# column type
	ctype = ""
	for i = 1:length(model.colCat)
		if model.colCat[i] == :Int
			ctype = ctype * "I";
		elseif model.colCat[i] == :Bin
			ctype = ctype * "B";
		else
			ctype = ctype * "C";
		end
	end
	ctype = convert(Vector{Uint8}, ctype)
	
	# objective coefficients
	obj, rlbd, rubd = JuMP.prepProblemBounds(model)
	
	return start, index, value, model.colLower, model.colUpper, ctype, obj, rlbd, rubd
end

function getNumScenarios()
	return @dsp_ccall("getNumScenarios", Cint, (Ptr{Void},), env.p)
end

function getNumRows(stage)
	return @dsp_ccall("getNumRows", Cint, (Ptr{Void}, Cint), env.p, convert(Cint, stage))
end

function getNumCols(stage)
	return @dsp_ccall("getNumCols", Cint, (Ptr{Void}, Cint), env.p, convert(Cint, stage))
end

function getNumRows()
	return getNumRows(DSP_FIRST_STAGE) + getNumScenarios() * getNumRows(env,DSP_SECOND_STAGE)
end

function getNumCols()
	return getNumCols(DSP_FIRST_STAGE) + getNumScenarios() * getNumCols(env,DSP_SECOND_STAGE)
end

function getObjCoef()
	num = getNumCols()
	obj = Array(Cdouble, num)
	@dsp_ccall("getObjCoef", Void, (Ptr{Void}, Ptr{Cdouble}), env.p, obj)
	return obj
end

function getSolutionTime()
	return @dsp_ccall("getSolutionTime", Cdouble, (Ptr{Void},), env.p)
end

function getSolutionStatus()
	status = @dsp_ccall("getSolutionStatus", Cint, (Ptr{Void},), env.p);
	if status == DSP_STAT_OPTIMAL
		return :Optimal
	elseif status == DSP_STAT_PRIM_INFEASIBLE
		return :PrimalInfeasible
	elseif status == DSP_STAT_DUAL_INFEASIBLE
		return :DualInfeasible
	elseif status == DSP_STAT_LIM_ITERorTIME
		return :IterOrTimeLimit
	elseif status == DSP_STAT_STOPPED_GAP
		return :StoppedGap
	elseif status == DSP_STAT_STOPPED_NODE
		return :StoppedNode
	elseif status == DSP_STAT_STOPPED_TIME
		return :StoppedTime
	elseif status == DSP_STAT_STOPPED_USER
		return :StoppedUser
	elseif status == DSP_STAT_STOPPED_SOLUTION
		return :StoppedSolution
	elseif status == DSP_STAT_STOPPED_ITER
		return :StoppedIter
	elseif status == DSP_STAT_STOPPED_UNKNOWN
		return :StoppedUnknown
	elseif status == DSP_STAT_STOPPED_MPI
		return :StoppedMPI
	elseif status == DSP_STAT_ABORT
		return :Abort
	elseif status == DSP_STAT_LIM_PRIM_OBJ
		return :PrimalObjLimit
	elseif status == DSP_STAT_LIM_DUAL_OBJ
		return :DualObjLimit
	else
		return :Unknown
	end
end

function getObjValue()
	return @dsp_ccall("getObjValue", Cdouble, (Ptr{Void},), env.p)
end

function getPrimalBound()
	return @dsp_ccall("getPrimalBound", Cdouble, (Ptr{Void},), env.p)
end

function getDualBound()
	return @dsp_ccall("getDualBound", Cdouble, (Ptr{Void},), env.p)
end

function getSolution(num::Integer)
	sol = Array(Cdouble, num)
	@dsp_ccall("getSolution", Void, (Ptr{Void}, Cint, Ptr{Cdouble}), env.p, num, sol)
	return sol
end

function getSolution()
	num = getNumCols()
	return getSolution(env,num)
end

function getNumIterations()
	return @dsp_ccall("getNumIterations", Cint, (Ptr{Void},), env.p)
end

function getNumNodes()
	return @dsp_ccall("getNumNodes", Cint, (Ptr{Void},), env.p)
end

