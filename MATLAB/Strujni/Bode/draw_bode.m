function draw_bode(tf, w)
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
    
    t = tiledlayout(2, 1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    
    nexttile
    semilogx(w, mag_dB, '-k','LineWidth', 1.5);
    hold on
    
    target = 2000*2*pi;
    tol = 1e-6 * target;   % relative tolerance

    % Mark poles on magnitude plot:
    for i = 1:length(p_sorted)
        if abs(p_sorted(i) - target) < tol
            lbl = sprintf('w_{filter}');
            xline(p_sorted(i), '--k', lbl, ...
                'LabelOrientation','horizontal', ...
                'LabelHorizontalAlignment', 'right', ...
                'LineWidth', 1.2);
        elseif p_sorted(i) > 0
            lbl = sprintf('wp_%d', i);
            xline(p_sorted(i), '--k', lbl, ...
                'LabelOrientation','horizontal', ...
                'LabelHorizontalAlignment', 'right', ...
                'LineWidth', 1.2);
        end
    end
    
    % Mark zeros on magnitude plot:
    for i = 1:length(z_sorted)
        if z_sorted(i) > 0
            lbl = sprintf('wz_%d', i);
            xline(z_sorted(i), '--k', lbl, ...
                'LabelOrientation','horizontal', ...
                'LabelHorizontalAlignment', 'left', ...
                'LineWidth', 1.2);
        end
    end
    
    grid on;
    ylabel('Magnitude (dB)');
    set(gca, 'FontSize', 11);

    ax = gca;
    
    % ---- 1. Set numeric ticks FIRST ----
    z_sorted = round(z_sorted(:)');
    p_sorted = round(p_sorted(:)');
    
    xticks_new = unique([ax.XTick(end), z_sorted, p_sorted]);
    xticks(xticks_new);
    
    drawnow;   % ensure labels are created
    
    % ---- 2. Modify ONLY the last label ----
    ticks  = ax.XTick;
    labels = ax.XTickLabel;
    
    n = round(log10(ticks(end)));
    labels{end} = sprintf('10^{%d}', n);
    
    ax.XTickLabel = labels;
    ax.TickLabelInterpreter = 'tex';
    
    % Create numeric labels with no decimals
    % xticklabels(arrayfun(@(x) num2str(x, '%.0f'), labels, 'UniformOutput', false));
    
    nexttile
    semilogx(w, phase_deg, '-k', 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency (rad/s)');
    ylabel('Phase (degrees)');
    set(gca, 'FontSize', 11);

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
