
function SciMLSensitivity.ODEForwardSensitivityProblem(mdl::PMModel, sensealg::SciMLSensitivity.AbstractForwardSensitivityAlgorithm = ForwardSensitivity();
    kwargs... )
    f = mdl._odeproblem.f
    parpairs = mdl.parameters.values
    conpairs = mdl.constants.values
    varpairs = mdl.states.values
    inpairs = mdl._inputs.values

    pars = [p.first for p in parpairs]
    cons = [c.first for c in conpairs]
    vars = [v.first for v in varpairs]
    ins = [i.first for i in inpairs]

    # pin = ModelingToolkit.varmap_to_vars(vcat(parpairs,conpairs), vcat(pars, cons))[1:lastindex(pars)]
    # u0in = ModelingToolkit.varmap_to_vars(vcat(varpairs, parpairs,conpairs), vcat(vars, pars, cons))[1:lastindex(vars)]
    pin = ModelingToolkit.varmap_to_vars(vcat(parpairs,inpairs, conpairs), vcat(pars, ins, cons))[1:(lastindex(pars)+lastindex(ins))]
    u0in = ModelingToolkit.varmap_to_vars(vcat(varpairs, parpairs, conpairs), vcat(vars, pars, cons))[1:lastindex(vars)]

    tspan = mdl.tspan
    sprob = SciMLSensitivity.ODEForwardSensitivityProblem(f, u0in, tspan, pin, sensealg; kwargs...)
    sens_prob = PMProbSens(deepcopy(mdl),sprob)
    return sens_prob
end

function PMParameterizedSolve.solve(sprob::PMProbSens, evs::Vector{PMEvent}, alg::Union{PMParameterizedSolve.DifferentialEquations.DEAlgorithm,Nothing} = nothing; kwargs...)
    mdl = sprob.mdl
    # Save parameters and inputs prior to solution. This will let us restore them after. # This could (PROBABLY WILL) have implications/cause problems for parallel solution...
    initP = mdl.parameters.values
    initU = mdl.states.values
    initIn = mdl.inputs.values
    cbs = PMParameterizedBase.collect_evs(evs, mdl)
    sol = solve(sprob.prob, alg; callback = cbs, kwargs...)
    # Restore values.
    mdl.parameters.values[:] = initP
    mdl.states.values[:] = initU
    mdl.states.parameters[:] = initP
    mdl.inputs.values[:] = initIn
    return sol
end