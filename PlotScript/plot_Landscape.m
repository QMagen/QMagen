% load('res_T34_600.mat')
load('res_YC46_150.mat')
% load res_T34_J2_1000.mat
set (gcf,'unit','centimeters','position', [1,2,50,24])
subplot(2,3,1)
% cs = [  0.99139    1.7163    -0.95799    0.10591     0       0     3.0069    3.7655];
% cs = [ 0.18173    1.9062    0.17893    0.34843    0.61649    0.066072    3.0493    3.8844];
% cs = [0.53348 1.9667  0.031 -0.10432 0.60189 0.25757 3.1991 3.9161];
[bs] = LandscapePlot(res, 'J1z', 'J1xy', 'log', 'FigDim', '2D');%, ...
       %'CrossSectionPoint', cs);

subplot(2,3,2)
[bs] = LandscapePlot(res, 'J1z', 'JPD', 'log', 'FigDim', '2D');%, ...
       %'CrossSectionPoint', cs);

subplot(2,3,3)
[bs] = LandscapePlot(res, 'J1z', 'JGamma', 'log', 'FigDim', '2D');%, ...
       %'CrossSectionPoint', cs);
   
% subplot(2,3,4)
% [bs] = LandscapePlot(res, 'J1z', 'J2xy', 'log', 'FigDim', '2D', ...
%        'CrossSectionPoint', cs);

subplot(2,3,5)
[bs] = LandscapePlot(res, 'J1z', 'gx', 'log', 'FigDim', '2D');%, ...
       %'CrossSectionPoint', cs);
   
subplot(2,3,6)
[bs] = LandscapePlot(res, 'J1z', 'gz', 'log', 'FigDim', '2D');%, ...
       %'CrossSectionPoint', cs);
   