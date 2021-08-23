% load res5_re-err.mat
load res_Delta=1.8.mat
% load('res_YC46_150.mat')
% [bs] = LandscapePlot(res, 'J1xy', 'JPD', 'log', 'FigDim', '2D');

[bs] = LandscapePlot(res, 'JPD', 'JGamma', 'log', 'FigDim', '2D');
