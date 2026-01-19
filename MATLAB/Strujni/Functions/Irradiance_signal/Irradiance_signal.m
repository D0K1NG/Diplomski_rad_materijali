function GI_signal = Irradiance_signal(Tend, Tstep, Gmin, Gmax)
% Tend  -> how long it lasts
% Tstep -> how long every step lasts

Ts    = 1e-3;    % [s]
t = (0:Ts:Tend)';

rng(1); % ponovljivo

% vremena promjene
t_change = 0:Tstep:Tend;

% razine ozračenja:
G_levels = Gmin + (Gmax-Gmin)*rand(size(t_change));

% prisili da barem jedna vrijednost bude Gmin i jedna Gmax
G_levels(1) = Gmin;
G_levels(end - 1) = Gmax;

% stepenasti signal (drži prethodnu vrijednost)
G = interp1(t_change, G_levels, t, 'previous', 'extrap');

% (po želji) clamp, iako je već u rasponu
G = max(Gmin, min(Gmax, G));


% LOW-PASS FILTER (uglađivanje)
tau = 0.003;                 % 50 ms vremenska konstanta
alpha = Ts/(tau + Ts);     % diskretni koeficijent

Gf = zeros(size(G));
Gf(1) = G(1);

for k = 2:numel(G)
    Gf(k) = (1-alpha)*Gf(k-1) + alpha*G(k);
end

% output
GI_signal = timeseries(Gf, t);

end

