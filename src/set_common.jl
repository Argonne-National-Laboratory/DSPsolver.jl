function setBoolParam(name::AbstractString, value::Bool)
	@dsp_ccall("setBoolParam", Void, (Ptr{Void}, Ptr{UInt8}, Cuchar), env.p, name, convert(Cuchar, value))
end

function setIntParam(name::AbstractString, value::Integer)
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Ptr{UInt8}, Cint), env.p, name, convert(Cint, value))
end

function setDblParam(name::AbstractString, value::Number)
	@dsp_ccall("setDblParam", Void, (Ptr{Void}, Ptr{UInt8}, Cdouble), env.p, name, convert(Cdouble, value))
end

function setStrParam(name::AbstractString, value::AbstractString)
	@dsp_ccall("setStrParam", Void, (Ptr{Void}, Ptr{UInt8}, Ptr{UInt8}), env.p, name, value)
end

function setBoolPtrParam(name::AbstractString, size::Integer, value::Bool)
	@dsp_ccall("setBoolPtrParam", Void, (Ptr{Void}, Ptr{UInt8}, Cint, Cuchar), env.p, name, convert(Cint, size), convert(Cuchar, value))
end

function setIntPtrParam(name::AbstractString, size::Integer, value::Int)
	@dsp_ccall("setIntPtrParam", Void, (Ptr{Void}, Ptr{UInt8}, Cint, Cint), env.p, name, convert(Cint, size), convert(Cint, value))
end

function setLogLevel(level::Integer)
	@dsp_ccall("setLogLevel", Void, (Ptr{Void}, Cint), env.p, convert(Cint, level))
end

function setNumCores(num::Integer)
	@dsp_ccall("setNumCores", Void, (Ptr{Void}, Cint), env.p, convert(Cint, num))
end

function setNodeLimit(num::Integer)
	@dsp_ccall("setNodeLimit", Void, (Ptr{Void}, Cint), env.p, convert(Cint, num))
end

function setIterLimit(num::Integer)
	@dsp_ccall("setIterLimit", Void, (Ptr{Void}, Cint), env.p, convert(Cint, num))
end

function setWallLimit(lim::Number)
	@dsp_ccall("setWallLimit", Void, (Ptr{Void}, Cdouble), env.p, convert(Cdouble, lim))
end

function setIntRelax(stage)
	@dsp_ccall("setIntRelax", Void, (Ptr{Void}, Cint), env.p, convert(Cint, stage))
end

function setProcIdxSet(scenarios::Array{Int,1})
	num = convert(Cint, length(scenarios));
	setIntPtrParam("ARR_PROC_IDX", num, scenarios);
end

# Set branch priorities
function setBranchPriorities(priorities::Array{Int,1})
	num = convert(Cint, length(priorities));
	@dsp_ccall("setBranchPrioties", Void, (Ptr{Void}, Cint, Ptr{Cint}), env.p, num, priorities);
end

# Set initial solution
# - This function can be called multiple times for setting multiple solutions.
function setSolution(solution::Array{Cdouble,1})
	num = convert(Cint, length(solution));
	@dsp_ccall("setSolution", Void, (Ptr{Void}, Cint, Ptr{Cdouble}), env.p, num, solution);
end
