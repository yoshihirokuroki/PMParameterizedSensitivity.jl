
module PMParameterizedSensitivity
    using Reexport
    using PMParameterizedBase
    import PMSimulatorBase: PMEvent
    import PMSimulatorSimulate: collect_evs
    @reexport using SciMLSensitivity
    import SciMLSensitivity: solve
    PMModel = PMParameterizedBase.PMModel
    ModelValues = PMParameterizedBase.ModelValues
    include("modelingTools.jl")
    export ODEForwardSensitivityProblem
    export solve
end
