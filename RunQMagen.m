clear all
addpath('lossfunc')
addpath('ManyBodySolver')
addpath (genpath('Config'))
addpath ('Class')

TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
Conf.many_body_solver = 'ED'; % 'ED', 'LTRG', 'XTRG'         % conf, BC, Mar13
Conf.ModelName = 'TLARK';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ GeomConf, ModelConf, Conf ] = SpinModel( Conf );

% =========================================================================
% DATA INPUT
% =========================================================================

CmData = ThermoData('Cm', [0,0,0], [1,40], 'C_expdata.mat'); % BC

if strcmp(ModelConf.Type_gFactor, 'dir')
    CmData.Info.g_info = {};
end


ChiData = ThermoData('Chi', [0,0,0.1], [1,40], 'Chi_expdata.mat');

if strcmp(ModelConf.gFactor_Vec, 'dir')
    ChiData.Info.g_info = {};
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
