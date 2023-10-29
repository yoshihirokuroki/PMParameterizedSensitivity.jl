
module PMParameterizedSensitivity
    using Reexport
    using PMParameterizedBase
    import PMSimulatorBase: PMEvent
    @reexport using SciMLSensitivity
    import SciMLSensitivity: solve
    PMModel = PMParameterizedBase.PMModel
    ModelValues = PMParameterizedBase.ModelValues
    include("modelingTools.jl")
    export ODEForwardSensitivityProblem
    export solve
end
