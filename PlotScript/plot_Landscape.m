
% ========= Plot Landscape in the parameter space ===== %
% Usage:
% (i) LandscapePlot(res, 'Para1', 'Para2', 'native/log', 'FigDim', '2D/3D')
% (ii) LandscapePlot(res, 'Para1', 'Para2', 'native/log', 'FigDim', '2D/3D', CrossSectionPoint)

% Input parameters: 
% "Para1", "Para2" are names of two parameters
% "native" or "log": native loss L or log10(L), [c.f. LossConf.Design in RunOpt_XX.m]
% 'FigDim', '2D' or '3D'
% 'CrossSectionPoint' - cross section through point [X1, X2, ...] [c.f.
% related model files in SpinMode folder]

% QMagen Collaboration: YG.BUAA & WL.ITP, 2021-08-30
% ====================================================== %

% load the result file (stored in "/Tmp/")
% load ../Tmp/tmp_20210829_213241/res3.mat
load res.mat

% //Plot the crosssection 
[bs] = LandscapePlot(res, 'Jxy', 'Jz', 'log', 'FigDim', '2D');