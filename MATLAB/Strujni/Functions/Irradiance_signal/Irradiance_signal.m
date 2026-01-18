function GI_signal = Irradiance_signal(Tend, Tstep, Gmin, Gmax)
% Tend  -> how long it lasts
% Tstep -> how long every step lasts

Ts    = 1e-3;    % [s]
t = (0:Ts:Tend)';

rng(1); % ponovljivo

% vremena promjene
t_change = 0:Tstep:Tend;

% razine ozračenja u [100, 900]
G_levels = Gmin + (Gmax-Gmin)*rand(size(t_change));

% stepenasti signal (drži prethodnu vrijednost)
G = interp1(t_change, G_levels, t, 'previous', 'extrap');

% (po želji) clamp, iako je već u rasponu
G = max(Gmin, min(Gmax, G));

GI_signal = timeseries(G, t);
end

