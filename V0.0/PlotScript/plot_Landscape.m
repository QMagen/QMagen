
% ========= Plot Landscape in the parameter space ===== %
% Usage:
% (1) LandscapePlot(res, 'Para1', 'Para2', LossDesign)
% (2) LandscapePlot(res, 'Para1', 'Para2', LossDesign, 'PARAM', val, ...)

% Input parameters: 
% "Para1", "Para2" are names of two parameters
% LossDesign: 'native' or 'log', native loss L or log10(L), [c.f. LossConf.Design in RunOpt_XX.m]
%
% PARAM:
%       FigDim   -default: '2D'
%                '2D' or '3D'

%       CrossSectPoint  -default 'MinObj'
%                Char: 'MinObj', 'MinEstObj', 'MinLandScape' [for general usr!]
%                Vect: [X1, X2, ...], pinpoint crosssection [for expert! c.f. model files in SpinMode folder]
%       CXRange: 
%                Set caxis range: [log10(L_min), Log10(L_max)]
%
% QMagen Collaboration: YG.BUAA & WL.ITP, 2021-08-30
% ====================================================== %
set(0, 'defaultfigurecolor', 'w')
% load the result file (stored in "/Tmp/")
% load ../Tmp/tmp_20210829_213241/res3.mat
load res.mat

% //Plot the crosssection 
[bs] = LandscapePlot(res, 'Jxy', 'Jz', 'log', 'FigDim', '2D', 'CXRange', [-4, 0]);
