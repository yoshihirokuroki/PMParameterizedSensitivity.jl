using DifferentialEquations
using SciMLSensitivity
function SciMLSensitivity.ODEForwardSensitivityProblem(mdl::PMModel, sensealg::SciMLSensitivity.AbstractForwardSensitivityAlgorithm = ForwardSensitivity();
    kwargs... )
    PMParameterizedBase.regenerateODEProblem!(mdl)
    f = mdl._odeproblem.f
    u0 = mdl._odeproblem.u0
    p = mdl._odeproblem.p
    sens_prob = SciMLSensitivity.ODEForwardSensitivityProblem(f, u0, tspan, p, sensealg; kwargs...)
    return sens_prob
end