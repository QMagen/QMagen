clear all
addpath('lossfunc')
addpath('ManyBodySolver')
addpath('UtilityFunc')
addpath (genpath('SpinModel'))
addpath ('Class')

TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
Conf.many_body_solver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
Conf.ModelName = 'TLARX';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ GeomConf, ModelConf, Conf ] = GetSpinModel( Conf );

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

CmData(1) = ThermoData('Cm', [0,0,0], [4,40], 'ExpData/TMGO_C_expdata_0T.mat'); 

if strcmp(ModelConf.Type_gFactor, 'dir')
    CmData(1).Info.g_info = {};
end


ChiData(1) = ThermoData('Chi', [0,0,0.1], [4,40], 'ExpData/TMGO_Chi_expdata_Sz.mat');

if strcmp(ModelConf.gFactor_Vec, 'dir')
    ChiData(1).Info.g_info = {};
end


% =========================================================================
lossconfig.weight_list = [];
lossconfig.loss_type = 'abs-err'; % 'abs-err', 'rel-err'
lossconfig.loss_design = 'native'; % 'native', 'log'
% =========================================================================
setting.plot_check = 0; % 0 -> off, 1 -> on

% Show information about evolution.
setting.EVO_check = 0;  % 0 -> off, 1 -> on

% Save intermediate results.
setting.res_save = 0;   % 0 -> off, 1 -> save the best, 2 -> save all

% The file name to save intermediate results.
setting.res_save_name = 'EDtest';


% =========================================================================

mkdir(['tmp_', TStr]);
if setting.res_save ~= 0
    mkdir([setting.res_save_name, '_', TStr])
end
save(['tmp_', TStr, '/exp_data.mat'], 'CmData', 'ChiData');
save(['tmp_', TStr, '/configuration.mat'], 'GeomConf', 'Conf', 'ModelConf', 'setting', 'lossconfig')
% =========================================================================
opt_func(TStr)
