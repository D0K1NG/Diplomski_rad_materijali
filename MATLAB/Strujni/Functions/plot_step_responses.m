function plot_step_responses(tf_struct, plot_data)
% tf_struct             -> struct containing transfer functions

% plot_data.t           -> time vector for step()
% plot_data.labels      -> transfer function labels
% plot_data.fgtitle     -> title of the figure
% plot_data.colors      -> curve colors

    arguments
        tf_struct struct
        plot_data struct
    end
    
    unpackStruct(plot_data);

    G = fieldnames(tf_struct);

    if isempty(G)
        error("TF struct can not be empty!");
    elseif numel(G) ~= numel(labels)
        error("Number of transfer functions and names is not the same!");
    elseif fgtitle == ""
        error("You need to specify figure title!");
    end

    % --- Handle colors ---
    n = numel(G);
    if isempty(colors)
        colors = lines(n); % nice default colormap
    elseif size(colors, 1) < n
        error("Not enough colors for all transfer functions!");
    end
    
    % --- Handle line styles ---
    if ~exist('linestyles','var') || isempty(linestyles)
        linestyles = repmat({'-'},1,n);   % default solid lines
    elseif numel(linestyles) < n
        error("Not enough line styles for all transfer functions!");
    end

    figure();
    hold on;

    for i = 1:n
        response = step(tf_struct.(G{i}), t);
        plot(t, response, ...
            'LineWidth', 1.5, ...
            'Color', colors(i,:), ...
            'LineStyle', linestyles{i});
    end

    ax = gca;
    % X-axis in milliseconds
    ax.XTickLabel = ax.XTick * 1000;  
    % Y-axis in millivolts
    ax.YTickLabel = ax.YTick * 1000; 
    hold off;
    grid on;
    xlabel('t [ms]');
    ylabel(y_label);
    legend(labels, 'Location', 'best');
    title(fgtitle);
end

