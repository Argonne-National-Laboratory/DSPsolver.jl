# Get functions for dual decomposition
# TODO: implement getDdMasterPrimalSolutions

# number of infeasible solutions evaluated
# number of master problem solved
for (func,name) in [(:getDdNumInfeasSolutions,"getDdNumInfeasSolutions"),
		    (:getDdNumMasterSolved,"getDdNumMasterSolved"),
		    (:getDdNumSubproblemSolved,"getDdNumSubproblemSolved")]
	@eval begin
		function $func()
			return @dsp_ccall($name, Cint, (Ptr{Void},), env.p)
		end
	end
end

# master solution cpu time per iteration
# master solution wall time per iteration
# history of master primal objective values
# history of master dual objective values
# subproblem solution cpu time per iteration
# subproblem solution wall time per iteration
# history of subproblem primal objective values
# history of subproblem dual objective values
for (func,name,sizefunc) in [(:getDdMasterCpuTimes,"getDdMasterCpuTimes",:getDdNumMasterSolved),
			     (:getDdMasterWallTimes,"getDdMasterWallTimes",:getDdNumMasterSolved),
			     (:getDdMasterPrimalBounds,"getDdMasterPrimalBounds",:getDdNumMasterSolved),
			     (:getDdMasterDualBounds,"getDdMasterDualBounds",:getDdNumMasterSolved),
			     (:getDdSubproblemCpuTimes,"getDdSubproblemCpuTimes",:getDdNumSubproblemSolved),
			     (:getDdSubproblemWallTimes,"getDdSubproblemWallTimes",:getDdNumSubproblemSolved),
			     (:getDdSubproblemPrimalBounds,"getDdSubproblemPrimalBounds",:getDdNumSubproblemSolved),
			     (:getDdSubproblemDualBounds,"getDdSubproblemDualBounds",:getDdNumSubproblemSolved)]
	@eval begin
		function $func()
			size = $sizefunc()
			val = Array(Cdouble, size)
			@dsp_ccall($name, Void, (Ptr{Void}, Ptr{Cdouble}), env.p, val)
			return val
		end
	end
end
