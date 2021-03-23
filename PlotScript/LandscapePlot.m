function LandscapePlot(res, xlab, ylab)
% function LandscapePlot(res, xlab, ylab)
% res is a BayesianOptimization class
% xlab is the paramater name of x axis
% ylab is the parameter name of y axis
bs = table2array(res.XAtMinObjective);

var_name = cell(length(res.VariableDescriptions), 1);

for i = 1:1:length(var_name)
    var_name{i} = res.VariableDescriptions(i).Name;
end

xpos = find(strcmp(var_name, xlab), 1);
ypos = find(strcmp(var_name, ylab), 1);

xrange = res.VariableDescriptions(xpos).Range;
yrange = res.VariableDescriptions(ypos).Range;

xlist = xrange(1):((xrange(2)-xrange(1))/100):xrange(2);
xlen = length(xlist);

ylist = yrange(1):((yrange(2)-yrange(1))/100):yrange(2);
ylen = length(ylist);

len = xlen * ylen;

[x_ms, y_ms] = meshgrid(xlist, ylist);

x_input = reshape(x_ms, [len, 1]);
y_input = reshape(y_ms, [len, 1]);

XTable = [];
for i = 1:1:length(var_name)
    if strcmp(xlab, var_name{i})
        XTable = setfield(XTable, var_name{i}, x_input);
    elseif strcmp(ylab, var_name{i})
        XTable = setfield(XTable, var_name{i}, y_input);
    else
        input_list = zeros(len, 1);
        input_list(:) = bs(i);
        XTable = setfield(XTable, var_name{i}, input_list);
    end
end

objective = predictObjective(res, struct2table(XTable));
objective_ms = reshape(objective, [ylen, xlen]);
[~, h] = contourf(x_ms, y_ms, objective_ms, 400);hold on
c = colorbar();
set(h,'LineColor','none');
set(gca, 'FontSize', 20, 'LineWidth', 1.5)
set(c, 'LineWidth', 1.5)
xlabel(xlab, 'FontSize', 20)
ylabel(ylab, 'FontSize', 20)
scatter(bs(xpos), bs(ypos), 100, 'ro', 'filled')
legend({'Predicted Mean', 'Best Objective point'}, 'FontSize', 20)
end