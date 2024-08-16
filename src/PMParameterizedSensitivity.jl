
module PMParameterizedSensitivity
    using Reexport
    using ..PMParameterizedBase
    import ..PMSimulatorBase.PMEvent
    import ..PMSimulatorBase.collect_evs
    using ..PMParameterizedSolve
    import DiffEqCallbacks: CallbackSet
    using SciMLSensitivity
    PMModel = PMParameterizedBase.PMModel
    ModelValues = PMParameterizedBase.ModelValues


    struct PMProbSens
        prob::SciMLSensitivity.DEProblem
        cbs::Union{CallbackSet, Nothing}
    end
    include("modelingTools.jl")
    export ODEForwardSensitivityProblem
    export solve
end
