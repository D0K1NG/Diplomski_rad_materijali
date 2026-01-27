function Upvref = mppt_my3(Upv1, Upv2, Ipv1, Ipv2)

zero_thresh = 1e-4;
epsilon = 0.01;
step_min = 0.005;
step_max = 0.2;

Upvref = Upv2;

% Lower bound for safety
% trzaji se javljaju zbog naglih promjena napona
% struja zavojnice skoci gore prije struja fotonapona (kasnjenja u sustavu)
% pogledaj kako struju ograniciti
if Upvref < 4
    Upvref = 4;
    return;
end

dUpv = Upv1 - Upv2;
dIpv = Ipv1 - Ipv2;

if (abs(dUpv) < zero_thresh)
    if (abs(dIpv) < zero_thresh)
        return;
    elseif (dIpv > 0)
        Upvref = Upvref + step_min;
        return;
    else 
        Upvref = Upvref - step_min;
        return;
    end
end

Gincr = dIpv/dUpv;
G = Ipv1/Upv1;
dPdU = Gincr + G;

if (abs(dPdU) > epsilon)
    step_var = min(step_max, 50*dPdU);
    if (dPdU > 0)
        Upvref = Upvref + step_var;
    else
        Upvref = Upvref - step_var;
    end
end

end

