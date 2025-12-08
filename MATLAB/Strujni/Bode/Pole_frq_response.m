function [mag_dB, phase_deg] = Pole_frq_response(w, wp)
%POLE_FRQ_RESPONSE Compute Bode magnitude (dB) and phase (deg) for a single pole.
%
%   [mag_dB, phase_deg] = pole_frq_response(w, wp)
%
%   Inputs:
%       w  - vector of frequencies (rad/s)
%       wp - pole break frequency (rad/s)
%
%   Outputs:
%       mag_dB    - magnitude in dB
%       phase_deg - phase in degrees
    
    arguments
        w   (1,:) double {mustBePositive}    % row vector of frequencies
        wp  (1,1) double {mustBePositive}    % scalar break frequency
    end


    mag_dB    = zeros(size(w));
    phase_deg = zeros(size(w));
    
    idx_p = w >= wp;
    mag_dB(idx_p) = mag_dB(idx_p) - 20*log10(w(idx_p)/wp);
    
    for i = 1:length(w)
        if w(i) <= wp/10
            ph_p = 0;
        elseif w(i) >= wp*10
            ph_p = -90;
        else
            % Liner interpolation (percentage of -90 deg)
            ph_p = -90 * (log10(w(i)) - log10(wp/10)) / (log10(wp*10) - log10(wp/10));
        end
        phase_deg(i) = phase_deg(i) + ph_p;
    end

end