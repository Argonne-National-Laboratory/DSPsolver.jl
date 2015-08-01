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

