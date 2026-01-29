function Upvref = mppt_my3(Upv1, Upv2, Ipv1, Ipv2)
% MPPT incremental conductance (hybrid) with robust numerics and anti-stall
% Inputs:  Upv1, Upv2  - PV voltage samples (previous, current) [V]
%          Ipv1, Ipv2  - PV current samples (previous, current) [A]
% Outputs: Upvref      - next PV voltage reference [V]
%          step        - applied step (Upvref - Upv2) [V]

% ---- Tunables ----
dU_small     = 0.01;     % [V] threshold for safe derivative fallback
zero_thresh  = 1e-4;     % [V]/[A] "no change" threshold
epsilon      = 1e-3;     % [W/V] near-zero slope threshold
k_step       = 20;       % step gain: V per (W/V)
step_min     = 0.01;     % [V] minimum perturb to avoid stalling
step_max     = 0.2;      % [V] maximum step magnitude
Umin         = 4.0;      % [V] lower clamp
Umax         = 6.2;      % [V] upper clamp
I_dark       = 1e-3;     % [A] "no irradiance" threshold

% Default: start from current voltage
Upvref = Upv2;

% ---- Safety clamps on input reference base ----
if Upvref < Umin
    Upvref = Umin;
elseif Upvref > Umax
    Upvref = Umax;
end

% ---- Dark / near-zero current handling ----
% If essentially no PV current, gently reduce reference to seek a valid point
if (Ipv1 <= I_dark) && (Ipv2 <= I_dark)
    Upvref = max(Umin, 0.9 * Upv2);
    return;
end

% ---- Differences ----
dUpv = Upv1 - Upv2;
dIpv = Ipv1 - Ipv2;

% If both changes are tiny, do a small dither (prevents freezing on noise)
if (abs(dUpv) < zero_thresh) && (abs(dIpv) < zero_thresh)
    Upvref = clamp(Upv2 + step_min, Umin, Umax);
    return;
end

% ---- Compute dP/dU robustly ----
% dP/dU = I + U * dI/dU
if abs(dUpv) > dU_small
    dIdU = dIpv / dUpv;
    dPdU = Ipv1 + Upv1 * dIdU;
else
    % Fallback: approximate slope by delta power / delta voltage direction
    % If voltage barely changed, use delta current sign as proxy
    dPdU = (Ipv1 - Ipv2);
end

% ---- Decide step ----
if abs(dPdU) > epsilon
    step_var = min(step_max, k_step * abs(dPdU));
    Upvref   = Upv2 + sign(dPdU) * step_var;
else
    % Near MPP: keep a tiny perturb so it doesn't stall
    % Use the last voltage direction if available; otherwise push up
    dir = 1;
    if abs(dUpv) > zero_thresh
        dir = sign(dUpv);
        if dir == 0, dir = 1; end
    end
    Upvref = Upv2 + dir * step_min;
end

% ---- Final clamp + output ----
Upvref = clamp(Upvref, Umin, Umax);

end

% Local helper (works in MATLAB R2016b+ as local function)
function y = clamp(x, lo, hi)
y = min(hi, max(lo, x));
end

