
% ========= Plot Landscape in the parameter space ===== %
% Usage:
% (1) LandscapePlot(res, 'Para1', 'Para2', LossDesign, FigDim)
% (2) LandscapePlot(res, 'Para1', 'Para2', LossDesign, FigDim, CrossSectPoint)
% (3) LandscapePlot(res, 'Para1', 'Para2', LossDesign, FigDim, CrossSectPoint, CXRange)

% Input parameters: 
% "Para1", "Para2" are names of two parameters
% LossDesign: 'native' or 'log', native loss L or log10(L), [c.f. LossConf.Design in RunOpt_XX.m]
% FigDim: '2D' or '3D'
% CrossSectPoint, Char: 'MinObj', 'MinEstObj', 'MinLandScape' [for general usr!]
% CrossSectPoint, Vect: [X1, X2, ...], pinpoint crosssection [for expert! c.f. model files in SpinMode folder]
% CXRange: Set caxis range: [log10(L_min), Log10(L_max)]

% QMagen Collaboration: YG.BUAA & WL.ITP, 2021-08-30
% ====================================================== %

% load the result file (stored in "/Tmp/")
% load ../Tmp/tmp_20210829_213241/res3.mat
load res3.mat

% //Plot the crosssection 
[bs] = LandscapePlot(res, 'Jxy', 'Jz', 'log', '2D', 'MinObj', [-4,-1]);