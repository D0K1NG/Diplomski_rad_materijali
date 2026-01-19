function fig = draw_bode(tf, w)
%   Inputs:
%       tf - system transfer function
%       w  - vector of frequencies (rad/s)

    % Time constants:
    z = zero(tf);
    p = pole(tf);
    [~, idx_z] = sort(abs(z), 'ascend'); % Sort zeros by magnitude
    [~, idx_p] = sort(abs(p), 'ascend'); % Sort poles by magnitude
    z_sorted = abs(z(idx_z));
    p_sorted = abs(p(idx_p));
    
    mag_total = 0;
    phase_total = 0;
    
    % Contribution of zeros
    for i = 1:length(z_sorted)
        [mag_z, ph_z] = Zero_frq_reponse(w, z_sorted(i));
        mag_total = mag_total + mag_z;
        phase_total = phase_total + ph_z;
    end
    
    % Contribution of poles
    for i = 1:length(p_sorted)
        if p_sorted(i) == 0 % pole at origin: integrator
            mag_total = mag_total - 20*log10(w);
            phase_total = phase_total - 90;
        else
            [mag_p, ph_p] = Pole_frq_response(w, p_sorted(i));
            mag_total = mag_total + mag_p;
            phase_total = phase_total + ph_p;
        end
    end
    
    % Include gain
    K = Get_tf_gain(tf);
    mag_dB = 20*log10(K) + mag_total;
    phase_deg = phase_total;
    
    % for 11 x 9 (W x H)
    width_px = round(11/2.54 * 300); % ~1335 pixels
    height_px = round(9/2.54 * 300); % ~1146 pixels

    fig = figure('Units','pixels', 'Position', [100 100 width_px height_px]); % W x H

    t = tiledlayout(2, 1);
    t.TileSpacing = 'compact';
    t.Padding = 'none';

    nexttile
    semilogx(w, mag_dB, '-k','LineWidth', 2);
    hold on
    
    yline(0, '-k', ...
    'LabelHorizontalAlignment', 'center', ...
    'LabelVerticalAlignment', 'bottom', ...
    'LineWidth', 1.2);

    % Pronađi presječnu frekvenciju (amplituda ≈ 0 dB)
    [~, idx_cross] = min(abs(mag_dB));  % indeks gdje je magnituda najbliža 0 dB
    wc = w(idx_cross);                 % pripadna frekvencija (rad/s)
    PM = phase_deg(idx_cross);

    % Crtaj vertikalnu liniju na toj frekvenciji
    xline(wc, '--k', sprintf('\\omega_c'), ...
    'LabelOrientation', 'horizontal', ...
    'LabelHorizontalAlignment', 'right', ...
    'FontSize', 16, ...
    'LineWidth', 1.2);

    k = 0;
    % Mark poles on magnitude plot:
    for i = 1:length(p_sorted)
        if p_sorted(i) > 0
            k = k + 1;
            xline(p_sorted(i),'--k',sprintf('\\omega_{p%d}',k), ...
                'LabelOrientation','horizontal', ...
                'LabelHorizontalAlignment','right', ...
                'FontSize', 16, ...
                'LineWidth',1.6);
        end
    end

    k = 0;
    % Mark zeros on magnitude plot:
    for i = 1:length(z_sorted)
        if z_sorted(i) > 0
            k = k + 1;
            xline(z_sorted(i),'--k',sprintf('\\omega_{z%d}',k), ...
                'LabelOrientation','horizontal', ...
                'LabelHorizontalAlignment','left', ...
                'FontSize', 16, ...
                'LineWidth',1.6);
        end
    end
    
    grid on;
    ylabel('\it{Amplituda (dB)}');
    set(gca, 'FontSize', 22, 'FontName', 'Times New Roman', 'XTickLabel', [], 'LineWidth', 1.6);
    
    nexttile
    semilogx(w, phase_deg, '-k', 'LineWidth', 2);
    hold on;
    yline(PM, '-k', sprintf('\\gamma_s = %d^\\circ', round(180 + PM)), ...
    'LabelHorizontalAlignment', 'right', ...
    'LabelVerticalAlignment', 'bottom', ...
    'FontSize', 22, ...
    'LineWidth', 1.2);
    grid on;
    xlabel('\it{Frekvencija (rad/s)}');
    ylabel('\it{Faza (^\circ)}');
    set(gca, 'FontSize', 22, 'FontName', 'Times New Roman', 'LineWidth', 1.6);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gain = Get_tf_gain(tf)

    % Calculate gain:
    [num, den] = tfdata(tf, 'v');
    
    % Get poles at origin:
    np_int = 0;
    for k = length(den):-1:1
        if den(k) == 0
            np_int = np_int + 1;
        else
            break
        end
    end
    
    % Get zeros at origin:
    nz_int = 0;
    for k = length(num):-1:1
        if num(k) == 0
            nz_int = nz_int + 1;
        else
            break
        end
    end
    
    % Remove zeros and poles at origin:
    num_no_int = num(1:end-nz_int);
    den_no_int = den(1:end-np_int);
    
    gain = num_no_int(end)/den_no_int(end);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
