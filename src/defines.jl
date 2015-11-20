# Return type
const DSP_STAT_OPTIMAL          = 3000;
const DSP_STAT_PRIM_INFEASIBLE  = 3001;
const DSP_STAT_DUAL_INFEASIBLE  = 3002;
const DSP_STAT_LIM_ITERorTIME   = 3004;
const DSP_STAT_STOPPED_GAP      = 3005;
const DSP_STAT_STOPPED_NODE     = 3006;
const DSP_STAT_STOPPED_TIME     = 3007;
const DSP_STAT_STOPPED_USER     = 3008;
const DSP_STAT_STOPPED_SOLUTION = 3009;
const DSP_STAT_STOPPED_ITER     = 3010;
const DSP_STAT_STOPPED_UNKNOWN  = 3011;
const DSP_STAT_STOPPED_MPI      = 3012;
const DSP_STAT_ABORT            = 3013;
const DSP_STAT_LIM_PRIM_OBJ     = 3014;
const DSP_STAT_LIM_DUAL_OBJ     = 3015;
const DSP_STAT_UNKNOWN          = 3999;

# Algorithm Type
const DSP_SOLVER_DE     = 0;
const DSP_SOLVER_BD     = 1;
const DSP_SOLVER_BD_MPI = 2;
const DSP_SOLVER_DD     = 3;

# Master algorithm of Dual decomposition
const SIMPLEX     = 0;
const IPM         = 1;
const IPM_FEAS    = 2;
const DSBM        = 3;
const SUBGRADIENT = 4;

const DSP_FIRST_STAGE  = 0;
const DSP_SECOND_STAGE = 1;

const DSP_NO  = 0;
const DSP_YES = 1;

type Env
	p::Ptr{Void}
	solver::Int
end

