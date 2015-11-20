function setDdProcIdxSet(scenarios::Array{Int,1})
	println("WARNING: setDdProcIdxSet() is deprecated. Please use setProcIdxSet() instead.");
	setProcIdxSet(scenarios);
end

function setDdAddFeasCuts(freq::Integer)
	@dsp_ccall("setDdAddFeasCuts", Void, (Ptr{Void}, Cint), env.p, convert(Cint, freq))
end

function setDdAddOptCuts(freq::Integer)
	@dsp_ccall("setDdAddOptCuts", Void, (Ptr{Void}, Cint), env.p, convert(Cint, freq))
end

function setDdEvalUb(freq::Integer)
	@dsp_ccall("setDdEvalUb", Void, (Ptr{Void}, Cint), env.p, convert(Cint, freq))
end

function setDdDualVarsLog(yesNo::Integer)
	@dsp_ccall("setDdDualVarsLog", Void, (Ptr{Void}, Cint), env.p, convert(Cint, yesNo))
end

function setDdCacheRecourse(yesNo::Integer)
	@dsp_ccall("setDdCacheRecourse", Void, (Ptr{Void}, Cint), env.p, convert(Cint, yesNo))
end

function setDdMasterSolver(solverType::Integer)
	@dsp_ccall("setDdMasterSolver", Void, (Ptr{Void}, Cint), env.p, convert(Cint, solverType))
end

function setDdMasterNumCutsPerIter(num::Integer)
	@dsp_ccall("setDdMasterNumCutsPerIter", Void, (Ptr{Void}, Cint), env.p, convert(Cint, num))
end

function setDdStoppingTolerance(tol::Number)
        @dsp_ccall("setDdStoppingTolerance", Void, (Ptr{Void}, Cdouble), env.p, convert(Cdouble, tol))
end

function setDdTrustRegionSize(num::Integer)
	@dsp_ccall("setDdTrustRegionSize", Void, (Ptr{Void}, Cint), env.p, convert(Cint, num))
end

function setDdDisableTrustRegionDecrease(yesNo::Bool)
	@dsp_ccall("setDdDisableTrustRegionDecrease", Void, (Ptr{Void}, Cuchar), env.p, convert(Cuchar, yesNo))
end
