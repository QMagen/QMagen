clear all
addpath('../lossfunc')
addpath('../ManyBodySolver')
addpath('../UtilityFunc')
addpath(genpath('../SpinModel'))
addpath('../Class')
addpath('../svd_lapack_interface')

% TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
Config.ManyBodySolver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
Config.ModelName = 'TLTI';
Config.Mode = 'OPT';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ Lattice, ModelConf, Config ] = GetSpinModel( Config );

% =========================================================================
% DATA INPUT
%
%       CmData:     Heat capacity experimental data 
%                   data(:,1) temperature   (K)
%                   data(:,2) heat capacity (J * mol^-1 * K^-1)
%
%       ChiData:    Susceptibility experimental data 
%                   data(:,1) temperature   (K)
%                   data(:,2) susceptibility(cm^3 * mol^-1 in SI unit)
% =========================================================================

CmData(1) = ThermoData('Cm', [0,0,0], [4,40], '../ExpData/TMGO_C_expdata_0T.mat'); 

if strcmp(ModelConf.gFactor_Type, 'dir')
    CmData(1).Info.g_info = {};
end


ChiData(1) = ThermoData('Chi', [0,0,0.1], [4,40], '../ExpData/TMGO_Chi_expdata_Sz.mat');

if strcmp(ModelConf.gFactor_Type, 'dir')
    ChiData(1).Info.g_info = {};
end

% =========================================================================
LossConf.WeightList = [];
LossConf.Type = 'abs-err'; % 'abs-err', 'rel-err'
LossConf.Design = 'log'; % 'native', 'log'

% =========================================================================
Setting.PLOTFLAG = 0; % 0 -> off, 1 -> on

% Save intermediate results.
Setting.SAVEFLAG = 1;   % 0 -> off, 1 -> save the best, 2 -> save all

% The file name to save intermediate results.
Setting.SAVENAME = 'TMGO';

QMagenConf = QMagen(Config, ModelConf, Lattice, LossConf, Setting, 'Cm', CmData, 'Chi', ChiData);

QMagenMain(QMagenConf)