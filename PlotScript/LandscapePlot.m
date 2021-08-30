function [bs] = LandscapePlot(res, xlab, ylab, LossDesign, varargin)
% function LandscapePlot(res, xlab, ylab, varargin)
% res is a BayesianOptimization class
% xlab is the paramater name of x axis
% ylab is the parameter name of y axis
% -------------------------------------------------
% Usage: LandscapePlot( BayesianOptimization, 'xlabelName', 'ylabelName', LossDesign, 'PARAM', val, ...)
%
%        LossDesign            -Design of loss function. The colorbar of
%                               landscape will be plot as log10(native). If
%                               you choose 'log' as your LossConfig.Design,
%                               then choose 'log' here.
%                               The following are accepted:
%                           'native'       
%                           'log'
%
%        'CrossSectionPoint'   -The cross section point of loss landscape.
%                               The following are accepted:
%                           'MinObj'       (default)
%                           'MinEstObj'
%                           'MinLandScape'
%                           [x1, x2, ..., xN]
%
%        'FigDim'              -The dimension of figure.
%                               The following are accepted:
%                           '2D'           (default)
%                           '3D'    
%        'CXRange',               caxis
% -------------------------------------------------
% QMagen Collaboration: YG.BUAA & WL.ITP, 2021-08-30
% --------------------------------------------------
Para.CrossSectionPoint = 'MinObj';
Para.LossDesign = LossDesign;
Para.FigDim = '2D';
Para.CXRange = [];

% //check input varargin
if mod(length(varargin),2)~=0       
    error('Illegal input format!')
end

for i = 1:1:(length(varargin)/2)
    if isfield(Para, varargin{2*i-1})
        Para = setfield(Para, varargin{2*i-1}, varargin{2*i});
    else
        error('Undefined input parameter!')
    end
end


% //assign CSP to bs
if ~ischar(Para.CrossSectionPoint)
    bs = Para.CrossSectionPoint;          % varargin pinpoint in vector
else
    switch Para.CrossSectionPoint         % varargin pinpoint in mode
        case 'MinObj'
            bs = table2array(res.XAtMinObjective);
        case 'MinEstObj'
            bs = table2array(res.XAtMinEstimateObjective);
        case 'MinLandScape'
            bs = table2array(res.XAtMinObjective);
            [bs,~,~,~] = fminsearch(@(x) pred(res, x), bs);
        otherwise        
            error('Illegal point!')     
    end
end


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

switch Para.LossDesign
    case 'native'
    case 'log'
        objective_ms = 10.^objective_ms;
    otherwise
        error('Undefined LossDesign')
end

% -------------------------------------------------------------------------
keypoint = [238, 233, 95
            158, 53, 43
            74, 55, 138
            0, 0, 0]/256;
len = [100, 100, 200, 200];
clear map;
for i = 1:1:length(keypoint(:,1))-1
    for j = 1:1:len(i)
        map(sum(len(1:1:(i-1))) + j, :) = keypoint(i, :) + (keypoint(i+1, :) - keypoint(i, :)) * (j-1)/len(i);
    end
end
colormap(map);
switch Para.FigDim
    case '2D'
        [~, h] = contourf(x_ms, y_ms, log10(abs(objective_ms)), 400);hold on
        c = colorbar();
        if ~isempty(Para.CXRange)
            caxis(Para.CXRange)
        end
        Ticks = c.Ticks;
        TickLabel = cell(1, length(Ticks));
        for i = 1:1:length(Ticks)
            TickLabel{i} = ['10^{', num2str(Ticks(i)), '}'];
        end
        set(c, 'yticklabel', TickLabel);
        set(h,'LineColor','none');
        set(gca, 'FontSize', 20, 'LineWidth', 1.5)
        set(c, 'LineWidth', 1.5)
        xlabel(xlab, 'FontSize', 20)
        ylabel(ylab, 'FontSize', 20)
        scatter(bs(xpos), bs(ypos), 100, 'kx', 'LineWidth', 1.5); hold on
        % legend({'Predicted Mean', 'Best Objective point'}, 'FontSize', 20)
    case '3D'
        surf(x_ms, y_ms, log10(abs(objective_ms))); hold on
        scatter(bs(xpos), bs(ypos), 100, 'kx', 'LineWidth', 1.5); hold on
        plot3([bs(xpos), bs(xpos)], [bs(ypos), bs(ypos)], [min(log10(objective)), max(log10(objective))], 'k', 'LineWidth', 2)
        grid off
        shading interp
        xlabel(xlab, 'FontSize', 15)
        ylabel(ylab, 'FontSize', 15)
        set(gca, 'FontSize', 20, 'LineWidth', 1.5)
end
hold off
end

function obj = pred(res, a)

for i = 1:1:length(a)
    var_name{i} = res.VariableDescriptions(i).Name;
end

XTable = struct(); 
for i = 1:1:length(a)
XTable = setfield(XTable, var_name{i}, a(i));
end
obj = predictObjective(res, struct2table(XTable));
end