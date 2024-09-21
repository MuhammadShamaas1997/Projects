%% Plot one tile in the figure
function ax = plotTile(tile, x, y, tilespan, xScale, titlelbl, ylbl, xlbl)
    ax = nexttile(tile, tilespan);
    plot(ax, x, y);
    title(ax, titlelbl);
    ylabel(ax, ylbl);
    xlabel(ax, xlbl);
    ymin = min(y, [], 'all');
    ymax = max(y, [], 'all');
    yspan = ymax - ymin;
    ax.YLim = [ymin - 0.1 * yspan ymax + 0.1 * yspan];
    if strcmp(xScale, 'log')
        ax.XLim = [x(find(x > 0, 1)) x(end)];
        ax.XScale = 'log';
    else
        ax.XLim = [0 x(end)];
    end
end
