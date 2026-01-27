function [Upvref, dP_dU, step] = mppt_my2(Upv1, Upv2, Ipv1, Ipv2)

zero_thresh = 1e-3;
epsilon = 0.01;
step_min = 0.005;
step_max = 0.2;

dU = Upv1 - Upv2;
dI = Ipv1 - Ipv2;

Upvref = Upv2;

if Upvref < 4
    Upvref = 4;
end

% Clamp dU to [-2, 2]
dU = max(min(dU, 2), -2);

dP_dU = 0;
step = step_min;
if (abs(dU) < zero_thresh)
    if (abs(dI) < zero_thresh)
        return;
    elseif (dI > 0)
        Upvref = Upvref + step;
    else 
        Upvref = Upvref - step;
    end
    return;
end

if Upv1 < zero_thresh
    Upv1 = zero_thresh;
end

Gincr = dI/dU;
G = Ipv1/Upv1;
dP_dU = Gincr + G;

if (abs(Gincr + G) > epsilon)
    % Adaptive step calculation
    scaling = abs(Gincr + G);               % Sensitivity
    scaling = min(max(scaling, 0), 1);      % Clamp to [0, 1]
    step_var = step_min + (step_max - step_min) * scaling;
    step = step_var;
    if (Gincr > -G)
        Upvref = Upvref + step;
    else
        Upvref = Upvref - step;
    end
end

end

