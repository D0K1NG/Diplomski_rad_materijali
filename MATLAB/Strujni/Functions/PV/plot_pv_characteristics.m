function fig = plot_pv_multiple_G(pv_list, color_list)
if nargin < 2
    default_colors = {'b', 'r', 'g', 'm', 'c', 'k'};
    color_list = default_colors(1:numel(pv_list));
end

% Figure size ~11x9 cm
width_px = round(11/2.54 * 300);
height_px = round(9/2.54 * 300);
fig = figure('Units','pixels', 'Position', [100 100 width_px height_px]);

% Font settings
set(fig, 'DefaultAxesFontName', 'Times New Roman', 'DefaultAxesFontSize', 24);
set(fig, 'DefaultTextFontName', 'Times New Roman', 'DefaultTextFontSize', 24);

hold on;

% Grid settings
grid on;
ax = gca;
ax.GridColor = [0.2 0.2 0.2];
ax.GridAlpha = 1;
ax.LineWidth = 0.8;
ax.GridLineStyle = '-';

% Axis labels
yyaxis left
ylabel("${Struja, I_{PV} [A]}$", 'Interpreter', 'latex');

yyaxis right
ylabel("${Snaga, P_{PV} [W]}$", 'Interpreter', 'latex');

xlabel("${Napon, U_{PV} [V]}$", 'Interpreter', 'latex');

n = numel(pv_list);
if ischar(color_list)
    color_list = cellstr(num2cell(color_list));
end

legend_handles = [];
legend_labels = {};

for i = 1:n
    pv = pv_list{i};
    col = color_list{i};

    % I-V curve
    yyaxis left
    hI = plot(pv.Upv, pv.Ipv, '-', 'Color', col, 'LineWidth', 2);
    plot(pv.Umpp, pv.Impp, 'xk', 'MarkerSize', 10, 'LineWidth', 2);

    % P-V curve
    yyaxis right
    plot(pv.Upv, pv.Ppv, '--', 'Color', col, 'LineWidth', 2);
    plot(pv.Umpp, pv.Pmpp, 'xk', 'MarkerSize', 10, 'LineWidth', 2);

    % Save I-V curve for legend
    legend_handles(end+1) = hI;
    legend_labels{end+1} = sprintf('$G = %d\\ \\mathrm{W/m^2}$', pv.G);

    % Single-line label: "Umpp V, Impp A"
    label_str = sprintf('%.1f V, %.2f A', pv.Umpp, pv.Impp);
    text(pv.Umpp, pv.Pmpp, ...
        label_str, ...
        'VerticalAlignment','bottom', ...
        'HorizontalAlignment','center', ...
        'FontSize', 18, 'FontName', 'Times New Roman', ...
        'FontWeight','bold', 'Interpreter','tex');
end

% Clean up ticks
yyaxis left
yticklabels('auto');

yyaxis right
yticklabels('auto');

xticklabels('auto');

% Set both Y axes to black
yyaxis left
ax = gca;
ax.YColor = 'k';

yyaxis right
ax.YColor = 'k';

% Final legend (only curves, no x markers)
legend(legend_handles, legend_labels, 'Interpreter', 'latex', 'Location', 'northeast');

set(gca, 'TickLabelInterpreter', 'tex');
set(findall(gcf,'type','text'), 'Color', 'k');
end






