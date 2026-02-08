function fig = plot_p_and_z(Gz_list, Gp, fig_title)
% plot_pz_multi_zeros  Plot poles and zeros from multiple TFs
%
% Inputs:
%   Gz_list   - cell array of TFs whose zeros are plotted
%               e.g. {G1, G2, G3}
%   Gp        - TF whose poles are plotted
%   fig_title - plot title (LaTeX allowed)

    if ~iscell(Gz_list)
        error('Gz_list must be a cell array of transfer functions.');
    end

    % Colors for different zero sets
    colors = {'r', 'g', 'm', 'c', 'y'};
    nColors = numel(colors);

    % Extract poles
    p = pole(Gp);

    % for 11 x 9 (W x H)
    width_px = round(15.52/2.54 * 300); % ~1335 pixels
    height_px = round(7.5/2.54 * 300); % ~1146 pixels

    fig = figure('Units','pixels', 'Position', [100 100 width_px height_px]); % W x H

    hold on;

    % ---- Zeros (multiple TFs) ----
    z_counter = 1;
    for i = 1:length(Gz_list)
        zi = zero(Gz_list{i});
        col = colors{mod(i-1, nColors)+1};

        for k = 1:length(zi)
            plot(real(zi(k)), imag(zi(k)), [col 'o'], ...
                'MarkerSize', 15, 'LineWidth', 2);

            text(real(zi(k)), imag(zi(k)), ...
                sprintf('\\omega_{z%d}', z_counter), ...
                'Interpreter', 'tex', ...
                'HorizontalAlignment', 'right', ...
                'VerticalAlignment', 'bottom', ...
                'FontSize', 24);

            z_counter = z_counter + 1;
        end
    end

    % ---- Poles ----
    for k = 1:length(p)
        plot(real(p(k)), imag(p(k)), 'bx', ...
            'MarkerSize', 15, 'LineWidth', 2);

        text(real(p(k)), imag(p(k)), ...
            sprintf('\\omega_{p%d}', k), ...
            'Interpreter', 'tex', ...
            'HorizontalAlignment', 'left', ...
            'VerticalAlignment', 'bottom', ...
            'FontSize', 24);
    end

    % ---- Axes formatting ----
    grid on;
    xlabel('\it Realna os \rm (\sigma)', 'Interpreter', 'tex');
    ylabel('\it Imaginarna os \rm (j\omega)', 'Interpreter', 'tex');

    if nargin == 3
        title(fig_title, 'Interpreter', 'latex');
    end

    set(gca, 'FontSize', 22, 'FontName', 'Times New Roman', 'LineWidth', 1.6);

    hold 