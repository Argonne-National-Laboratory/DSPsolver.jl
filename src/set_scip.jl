function setScipDisplayFreq(freq::Integer)
	@dsp_ccall("setScipDisplayFreq", Void, (Ptr{Void}, Cint), env.p, convert(Cint, freq))
end

function setScipLimitsGap(gap::Number)
	@dsp_ccall("setScipLimitsGap", Void, (Ptr{Void}, Cdouble), env.p, convert(Cdouble, gap))
end

function setScipLimitsTime(time::Number)
	@dsp_ccall("setScipLimitsTime", Void, (Ptr{Void}, Cdouble), env.p, convert(Cdouble, time))
end

