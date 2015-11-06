function setBoolParam(name::AbstractString, value::Bool)
	@dsp_ccall("setBoolParam", Void, (Ptr{Void}, Cstring, Cuchar), env.p, name, convert(Cuchar, value))
end

function setIntParam(name::AbstractString, value::Integer)
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cint), env.p, name, convert(Cint, value))
end

function setDblParam(name::AbstractString, value::Number)
	@dsp_ccall("setDblParam", Void, (Ptr{Void}, Cstring, Cdouble), env.p, name, convert(Cdouble, value))
end

function setStrParam(name::AbstractString, value::AbstractString)
	@dsp_ccall("setStrParam", Void, (Ptr{Void}, Cstring, Cstring), env.p, name, convert(Cstring, value))
end

function setBoolPtrParam(name::AbstractString, size::Integer, value::Array{Bool,1})
	@dsp_ccall("setBoolPtrParam", Void, (Ptr{Void}, Cstring, Cint, Ptr{Cuchar}), env.p, name, convert(Cint, size), convert(Vector{Cuchar}, value))
end

function setIntPtrParam(name::AbstractString, size::Integer, value::Array{Int,1})
	@dsp_ccall("setIntPtrParam", Void, (Ptr{Void}, Cstring, Cint, Ptr{Cint}), env.p, convert(Vector{Cuchar}, name), convert(Cint, size), convert(Vector{Cint}, value))
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

