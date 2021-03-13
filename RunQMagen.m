clear all
addpath lossfunc
addpath ManyBodySolver
addpath Config

TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
Conf.many_body_solver = 'ED'; % 'ED', 'LTRG', 'XTRG'         % conf, BC, Mar13
Conf.ModelName = 'TLTI';

Conf.d = 2;
Conf.L = 9;

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ GeomConf, ModelConf, Conf ] = SpinModel( Conf );
% =========================================================================
% DATA INPUT
% =========================================================================
Cmdata.len = 1;
Cmdata.Field = cell(Cmdata.len, 1);
Cmdata.Trange = cell(Cmdata.len, 1);
Cmdata.data = cell(Cmdata.len, 1);

Cmdata.Field{1} = [0,0,0];
Cmdata.data{1} = struct2array(load('C_expdata.mat', 'C_data'));
Cmdata.Trange{1} = [1, 40];

if strcmp(ModelConf.Type_gFactor, 'dir')
    CmData.g_info = {};
end

Chidata.len = 1;
Chidata.Field = cell(Chidata.len, 1);
Chidata.data = cell(Chidata.len, 1);

Chidata.Field{1} = [0,0,0.1];
Chidata.data{1} = struct2array(load('Chi_expdata.mat', 'Chi_data'));
Chidata.Trange{1} = [1, 40];

if strcmp(ModelConf.gFactor_Vec, 'dir')
    Chidata.g_info = {};
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
save(['tmp_', TStr, '/exp_data.mat'], 'Cmdata', 'Chidata');
save(['tmp_', TStr, '/configuration.mat'], 'GeomConf', 'Conf', 'ModelConf', 'setting', 'lossconfig')
% =========================================================================
opt_func(TStr)
