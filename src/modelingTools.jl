function SciMLSensitivity.ODEForwardSensitivityProblem(mdl::PMModel, evs::Vector{PMEvent}, sensealg::SciMLSensitivity.AbstractForwardSensitivityAlgorithm = ForwardSensitivity();
    kwargs... )
    f = mdl._odeproblem.f
    initP = deepcopy(mdl.parameters.values)
    initU = deepcopy(mdl.states.values)
    initIn = deepcopy(mdl._inputs.values)

    cbs = collect_evs(evs, mdl)
    parpairs = deepcopy(mdl.parameters.values)
    conpairs = deepcopy(mdl.constants.values)
    varpairs = deepcopy(mdl.states.values)
    inpairs = deepcopy(mdl._inputs.values)

    # Restore values after CB generation
    mdl.parameters.values[:] = initP
    mdl.states.values[:] = initU
    mdl.states.parameters.values[:] = initP
    mdl._inputs.values[:] = initIn

    pin = ModelingToolkit.varmap_to_vars(vcat(parpairs, inpairs, conpairs), ModelingToolkit.parameters(mdl.model))
    u0in = ModelingToolkit.varmap_to_vars(vcat(varpairs, parpairs, conpairs), ModelingToolkit.states(mdl.model))
    tspan = mdl.tspan
    sprob = SciMLSensitivity.ODEForwardSensitivityProblem(f, u0in, tspan, pin, sensealg; kwargs...)
    sens_prob = PMProbSens(sprob, cbs)
    return sens_prob
end


function SciMLSensitivity.ODEForwardSensitivityProblem(mdl::PMModel, sensealg::SciMLSensitivity.AbstractForwardSensitivityAlgorithm = ForwardSensitivity();
    kwargs... )
    f = mdl._odeproblem.f


    parpairs = deepcopy(mdl.parameters.values)
    conpairs = deepcopy(mdl.constants.values)
    varpairs = deepcopy(mdl.states.values)
    inpairs = deepcopy(mdl._inputs.values)
    # Restore values after CB generation

    pin = ModelingToolkit.varmap_to_vars(vcat(parpairs, inpairs, conpairs), ModelingToolkit.parameters(mdl.model))
    u0in = ModelingToolkit.varmap_to_vars(vcat(varpairs, parpairs, conpairs), ModelingToolkit.states(mdl.model))

    tspan = mdl.tspan
    sprob = SciMLSensitivity.ODEForwardSensitivityProblem(f, u0in, tspan, pin, sensealg; kwargs...)
    sens_prob = PMProbSens(sprob, nothing)
    return sens_prob
end


function PMParameterizedSolve.solve(sprob::PMProbSens, alg::Union{PMParameterizedSolve.DifferentialEquations.DEAlgorithm,Nothing} = nothing; kwargs...)
    cbs = sprob.cbs
    sol = solve(sprob.prob, alg; callback = cbs, kwargs...)
    return sol
end