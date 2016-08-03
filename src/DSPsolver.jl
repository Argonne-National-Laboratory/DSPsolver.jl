module DSPsolver

# package code goes here
import JuMP
import StochJuMP
import MPI

export DSP_SOLVER_DE, DSP_SOLVER_BD, DSP_SOLVER_BD_MPI, DSP_SOLVER_DD
export SIMPLEX, IPM, IPM_FEAS, DSBM, SUBGRADIENT
export DSP_FIRST_STAGE, DSP_SECOND_STAGE
export DSP_YES, DSP_NO
export DSP_STAT_OPTIMAL
export DSP_STAT_PRIM_INFEASIBLE
export DSP_STAT_DUAL_INFEASIBLE
export DSP_STAT_LIM_ITERorTIME
export DSP_STAT_STOPPED_GAP
export DSP_STAT_STOPPED_NODE
export DSP_STAT_STOPPED_TIME
export DSP_STAT_STOPPED_USER
export DSP_STAT_STOPPED_SOLUTION
export DSP_STAT_STOPPED_ITER
export DSP_STAT_STOPPED_UNKNOWN
export DSP_STAT_STOPPED_MPI
export DSP_STAT_ABORT
export DSP_STAT_LIM_PRIM_OBJ
export DSP_STAT_LIM_DUAL_OBJ
export DSP_STAT_UNKNOWN

include("compatibility.jl")
include("defines.jl")
include("common.jl")

# Initialize DSP
env = Env(@dsp_ccall("createEnv", Ptr{Void}, ()), DSP_SOLVER_DD)
finalizer(env, freeDSP); # Register finalizer

include("get_common.jl")
include("get_dd.jl")
include("set_common.jl")
include("set_dd.jl")
include("set_scip.jl")
include("dsp_model.jl")
include("dsp_solver.jl")
include("dsp_dec.jl")

end # module
