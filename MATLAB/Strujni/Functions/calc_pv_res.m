function pv = calc_pv_res(model, params)
% model     -> simulink model name
% params    -> struct containing model parameters 
%              (irradiance, temperature, ramp slope)

    arguments
        model (1,1) string
        params struct
    end
    
    simIn = Simulink.SimulationInput(model);
    paramNames = fieldnames(params);

    % inject variables into simulink:
    for i = 1:numel(paramNames)
        simIn = simIn.setVariable(paramNames{i}, params.(paramNames{i}));
    end

    SimOut = sim(simIn);
    R_pv_sim = SimOut.get("Rpv_sim").Data;
    
    for i = 1:length(R_pv_sim)
        if R_pv_sim(i) == inf
            R_pv_sim(i) = 1000;
        end
    end
    pv.Rpv = R_pv_sim;
    pv.Upv = SimOut.get("Upv_sim").Data;
end

