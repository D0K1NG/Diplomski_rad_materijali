function [mag_dB, phase_deg] = Zero_frq_reponse(w, wz)
%ZERO_FRQ_RESPONSE Compute Bode magnitude (dB) and phase (deg) for a single zero.
%
%   [mag_dB, phase_deg] = Zero_frq_response(w, wz)
%
%   Inputs:
%       w  - vector of frequencies (rad/s)
%       wz - zero break frequency (rad/s)
%
%   Outputs:
%       mag_dB    - magnitude in dB
%       phase_deg - phase in degrees

    
    arguments
        w   (1,:) double {mustBePositive}    % row vector of frequencies
        wz  (1,1) double {mustBePositive}    % scalar break frequency
    end


    mag_dB    = zeros(size(w));
    phase_deg = zeros(size(w));
    
    idx_z = w >= wz;
    mag_dB(idx_z) = mag_dB(idx_z) + 20*log10(w(idx_z)/wz);
    
    for i = 1:length(w)
        if w(i) <= wz/10
            ph_z = 0;
        elseif w(i) >= wz*10
            ph_z = 90;
        else
            % Liner interpolation (percentage of 90 deg)
            ph_z = 90 * (log10(w(i)) - log10(wz/10))/(log10(wz*10) - log10(wz/10));
        end
        phase_deg(i) = phase_deg(i) + ph_z;
    end

end

