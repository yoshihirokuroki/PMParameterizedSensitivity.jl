
module PMParameterizedSensitivity
    using Reexport
    using PMParameterizedBase
    @reexport using SciMLSensitivity
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
