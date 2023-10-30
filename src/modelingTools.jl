
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
    sens_prob = SciMLSensitivity.ODEForwardSensitivityProblem(f, u0in, tspan, pin, sensealg; kwargs...)
    return sens_prob
end



# function SciMLSensitivity.ODEForwardSensitivityProblem(mdl_in::PMModel, evs::Vector{PMEvent}, sensealg::SciMLSensitivity.AbstractForwardSensitivityAlgorithm = ForwardSensitivity();
#     kwargs... )
#     mdl = deepcopy(mdl_in)
#     cbs = collect_evs(evs, mdl)
#     parpairs = mdl.parameters.values
#     conpairs = mdl.constants.values
#     varpairs = mdl.states.values
#     inpairs = mdl._inputs.values

#     pars = [p.first for p in parpairs]
#     cons = [c.first for c in conpairs]
#     vars = [v.first for v in varpairs]
#     ins = [i.first for i in inpairs]

#     pin = ModelingToolkit.varmap_to_vars(vcat(parpairs,inpairs, conpairs), vcat(pars, ins, cons))[1:(lastindex(pars)+lastindex(ins))]
#     u0in = ModelingToolkit.varmap_to_vars(vcat(varpairs, parpairs, conpairs), vcat(vars, pars, cons))[1:lastindex(vars)]

#     tspan = mdl.tspan

#     sens_prob = SciMLSensitivity.ODEForwardSensitivityProblem(mdl._odeproblem.f, u0in, tspan, pin, sensealg; callback = cbs, kwargs...)

#     return (sens_prob,cbs)
# end

