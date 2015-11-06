function setBoolParam(name::String, value::Bool)
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cuchar), env.p, name, convert(Cuchar, value))
end

function setIntParam(name::String, value::Integer)
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cint), env.p, name, convert(Cint, value))
end

function setDblParam(name::String, value::Number)
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cdouble), env.p, name, convert(Cdouble, value))
end

function setStrParam(name::String, value::String)
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cstring), env.p, name, convert(Cstring, value))
end

function setBoolPtrParam(name::String, size::Integer, value::Array{Bool,1})
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cint, Cuchar), env.p, name, size, convert(Vector{Cuchar}, value))
end

function setIntPtrParam(name::String, size::Integer, value::Array{Integer,1})
	@dsp_ccall("setIntParam", Void, (Ptr{Void}, Cstring, Cint, Cuchar), env.p, name, size, convert(Vector{Cint}, value))
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

