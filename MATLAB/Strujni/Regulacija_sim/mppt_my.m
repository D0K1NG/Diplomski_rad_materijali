function Upv_ref = mppt_my(Upv_2, Upv_1, Ipv_2, Ipv_1)

% Base incr:
base_incr = 0.1;
if abs(Upv_2) < 0.01
    incr = base_incr;
else
    % incr = base_incr * abs(1/Upv_2);
    incr = base_incr * min(10, abs(1 / max(Upv_2, 1e-3)));
end

% Sensitivity:
e = 0.01;

deltaU = Upv_2 - Upv_1;
deltaI = Ipv_2 - Ipv_1;

if abs(deltaU) < e
    if abs(deltaI) < e
        Upv_ref = Upv_1;
    elseif deltaI > 0
        Upv_ref = Upv_2 + incr;
    else
        Upv_ref = Upv_2 - incr;
    end
else
    % Calculate istant conductance:
    inst_cond = Ipv_1 / max(Upv_1, 1e-6);  % izbjegava ekstremne skokove
    % -----------------------------
    incr_cond = deltaI/deltaU;

    if abs(incr_cond + inst_cond) < e
        Upv_ref = Upv_1;
    elseif incr_cond > - inst_cond
        Upv_ref = Upv_2 + incr;
    else
        Upv_ref = Upv_2 - incr;
    end
end

% Logging data:
% persistent log_data;
% if isempty(log_data):
%     log_data = zeros(100, 5);
% else
%     log_data = [log_data(2:, :), Upv_1, Upv_2, deltaU, deltaI, Upv_ref];
% end
% log_data = [Upv_1, Upv_2, incr, Upv_ref];

