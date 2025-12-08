function plot_step_response(sys_tf, plot_data)
% tf                    -> system transfer function

% plot_data.t           -> time vector for step()
% plot_data.label      -> transfer function label
% plot_data.fgtitle     -> title of the figure
% plot_data.color       -> curve color

    arguments
        sys_tf tf
        plot_data struct
    end

    unpackStruct(plot_data)
    
    figure();
    hold on;

    response = step(sys_tf, t);
    plot(t, response, 'LineWidth', 1.5, 'Color', color);

    ax = gca;
    % X-axis in milliseconds
    ax.XTickLabel = ax.XTick * 1000;  
    % Y-axis in millivolts
    ax.YTickLabel = ax.YTick * 1000; 
    hold off;
    grid on;
    xlabel('t [ms]');
    ylabel(y_label);
    title(fgtitle);
end