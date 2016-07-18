macro dsp_ccall(func, args...)
	@unix_only return quote
		ccall(($func, "libDsp"), $(args...))
	end
	@windows_only return quote
		ccall(($func, "libDsp"), stdcall, $(args...))
	end
end

function freeDSP(env::Env)
	if env.p == C_NULL
		return
	end
	@dsp_ccall("freeEnv", Void, (Ptr{Void},), env.p)
	env.p = C_NULL
	return
end

function check_problem()
	if env.p == C_NULL
		error("Invalid DSP environment pointer")
	end
	return true
end

function prepConstrMatrix(m::JuMP.Model)
    if !haskey(m.ext, :Stochastic)
        return JuMP.prepConstrMatrix(m)
    end

    stoch = StructJuMP.getStructure(m)
    if stoch.parent == nothing
    	return JuMP.prepConstrMatrix(m)
    else
        rind = Int[]
        cind = Int[]
        value = Float64[]
        linconstr = deepcopy(m.linconstr)
        for (nrow,con) in enumerate(linconstr)
            aff = con.terms
            for (var,id) in zip(reverse(aff.vars), length(aff.vars):-1:1)
                push!(rind, nrow)
                if m.linconstr[nrow].terms.vars[id].m == stoch.parent
                    push!(cind, var.col)
                elseif m.linconstr[nrow].terms.vars[id].m == m
                    push!(cind, stoch.parent.numCols + var.col)
                end
                push!(value, aff.coeffs[id])
                splice!(aff.vars, id)
                splice!(aff.coeffs, id)
            end
        end
    end
    return sparse(rind, cind, value, length(m.linconstr), stoch.parent.numCols + m.numCols)
end


