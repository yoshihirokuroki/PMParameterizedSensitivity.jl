
module PMParameterizedSensitivity
    using Reexport
    using PMParameterizedBase
    import PMSimulatorBase: PMEvent
    import PMSimulatorBase: collect_evs
    @reexport using SciMLSensitivity
    import SciMLSensitivity: solve
    PMModel = PMParameterizedBase.PMModel
    ModelValues = PMParameterizedBase.ModelValues

    struct PMProbSens
        mdl::PMModel
        prob::SciMLSensitivity.DEProblem
    end



    include("modelingTools.jl")
    export ODEForwardSensitivityProblem
    export solve
end
