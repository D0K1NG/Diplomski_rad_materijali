function plot_pz(sys, name, znames, pnames)
    % sys    = transfer function
    % name   = title string (LaTeX format)
    % znames = array of strings or cell array for zero labels
    % pnames = array of strings or cell array for pole labels

    % Poles and zeros
    z = zero(sys);
    p = pole(sys);

    % Plot
    hold on;
    plot(real(z), imag(z), 'ro', 'MarkerSize', 15, 'LineWidth', 2);
    plot(real(p), imag(p), 'bx', 'MarkerSize', 15, 'LineWidth', 2);
    grid on;
    xlabel('$Realna$ $os$', 'Interpreter', 'latex');
    ylabel('$Imaginarna$ $os$', 'Interpreter', 'latex');
    title(name, 'Interpreter', 'latex');

    % ---- Annotate zeros ----
    % if ~isempty(z) && nargin >= 3 && ~isempty(znames)
    %     for i = 1:min(length(z), length(znames))
    %         text(real(z(i)), imag(z(i)), znames(i), ...
    %             'Interpreter', 'tex', ...
    %             'HorizontalAlignment', 'right', ...
    %             'VerticalAlignment', 'bottom', ...
    %             'FontSize', 24);
    %     end
    % end

    % ---- Annotate zeros with offset and unique colors ----
    
    if ~isempty(z) && nargin >= 3 && ~isempty(znames)
    
        colors = lines(length(z));   % distinct colors
        dx = 0.02 * range(real(z));  % horizontal offset
        dy = 0.02 * range(real(z));  % vertical offset
    
        for i = 1:min(length(z), length(znames))
            % Plot zero with unique color
            plot(real(z(i)), imag(z(i)), 'o', ...
                 'Color', colors(i,:), ...
                 'MarkerSize', 15, ...
                 'LineWidth', 2);
    
            % Offset labels alternately to avoid overlap
            text(real(z(i)) + dx, imag(z(i)) + (-1)^(i)*dy, ...
                 znames(i), ...
                 'Interpreter', 'tex', ...
                 'Color', colors(i,:), ...
                 'FontSize', 24, ...
                 'HorizontalAlignment', 'left', ...
                 'VerticalAlignment', 'middle');
        end
    end


    % ---- Annotate poles ----
    if ~isempty(p) && nargin >= 4 && ~isempty(pnames)
        for i = 1:min(length(p), length(pnames))
            text(real(p(i)), imag(p(i)), pnames(i), ...
                'Interpreter', 'tex', ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', ...
                'FontSize', 24);
        end
    end

    hold off;
end
