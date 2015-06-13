function setBdAugScenarios(num::Integer, scenarios::Array{Int,1})
	scenarios = convert(Vector{Cint}, scenarios)
	@dsp_ccall("setBdAugScenarios", Void, (Ptr{Void}, Cint, Ptr{Cint}), env.p, convert(Cint, num), scenarios)
end

function setBendersAggressive(aggressive::Integer)
	@dsp_ccall("setBendersAggressive", Void, (Ptr{Void}, Cint), env.p, convert(Cint, aggressive))
end

