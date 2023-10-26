using PMParameterizedBase
using PMParameterizedSensitivity

mod = @model mod begin
    @IVs t [unit = u"hr", description = "time", tspan = (0.0, 100.0)]
    D = Differential(t)

    @constants begin
        day_to_h = 24.0
    end

    @parameters begin 
        CL_ADC = 0.0043/day_to_h, [unit = u"L/hr", description = "central clearance"]
        CLD_ADC = 0.014/day_to_h, [unit = u"L/hr", description = "intercompartmental clearance"]
        V1_ADC = 0.034,       [unit = u"L", description = "central volume"]
        V2_ADC = 0.04,        [unit = u"L", description = "peripheral volume"]
    end


    @variables begin
        (X1_ADC_nmol(t) = 0.0), [unit = u"nmol", description = "ADC amount in Compartment 1"]
        (X2_ADC_nmol(t) = 0.0), [unit = u"nmol", description = "ADC amount in Compartment 2"]
    end

 @eq D(X1_ADC_nmol) ~ -(CL_ADC/V1_ADC)*X1_ADC_nmol - (CLD_ADC/V1_ADC)*X1_ADC_nmol + (CLD_ADC/V2_ADC)*X2_ADC_nmol
 @eq D(X2_ADC_nmol) ~ (CLD_ADC/V1_ADC)*X1_ADC_nmol - (CLD_ADC/V2_ADC)*X2_ADC_nmol
end;

MW = 148781.0                                   # [g/mol] T-DM1 molecular weight (Scheuher et al 2022)
BW = 70                                         # [kg] human body weight
dose_in_mgkg = 3.6                              # mg/kg per Girish 2012 data
dose = (dose_in_mgkg * 1e-3 * BW) / (MW / 1e9)  # nmol

# Set initial condition in first compartment 
mod.states.X1_ADC_nmol = dose
# Update simulation tspan
mod.tspan = (0.0, 21.0*24.0)

prob_sens = ODEForwardSensitivityProblem(mod);
sol_sens = solve(prob_sens);
x, dp = extract_local_sensitivities(sol_sens);