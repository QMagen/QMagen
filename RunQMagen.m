clear all
addpath lossfunc
addpath ManyBodySolver
addpath Config

TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
conf.many_body_solver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
conf.d = 2;

if strcmp(conf.many_body_solver, 'ED') || strcmp(conf.many_body_solver, 'XTRG')
    conf.IntrcMap_name = 'IntrcMap_TLTI';
    conf.L = 9;
end

if strcmp(conf.many_body_solver, 'iLTRG')
    conf.trotter_name = 'tortter_AAFHC';
end

% =========================================================================
Geo.Lx = 3;
Geo.Ly = 3;
Geo.BCX = 'OBC';
Geo.BCY = 'PBC';
ModelConf.Para = {'J1', 'J2', 'Delta'};
ModelConf.Para_opt_range = {[5, 20], [0, 5], [0, 12]};

ModelConf.g_len = 1;
ModelConf.g_def = 'xyz'; % 'xyz', 'dir'

ModelConf.g = cell(ModelConf.g_len, 1);
ModelConf.g_vec = cell(ModelConf.g_len, 1);
ModelConf.g_opt_range = cell(ModelConf.g_len, 1);

ModelConf.g{1} = 'gz';
ModelConf.g_vec{1} = [0,0,1];
ModelConf.g_opt_range{1} = [5, 20]; 
% =========================================================================
Cmdata.len = 1;
Cmdata.Field = cell(Cmdata.len, 1);
Cmdata.Trange = cell(Cmdata.len, 1);
Cmdata.data = cell(Cmdata.len, 1);

Cmdata.Field{1} = [0,0,0];
Cmdata.data{1} = struct2array(load('C_expdata.mat', 'C_data'));
Cmdata.Trange{1} = [1, 40];

if strcmp(ModelConf.g_def, 'dir')
    Cmdata.g_info = {};
end

Chidata.len = 1;
Chidata.Field = cell(Chidata.len, 1);
Chidata.data = cell(Chidata.len, 1);

Chidata.Field{1} = [0,0,0.1];
Chidata.data{1} = struct2array(load('Chi_expdata.mat', 'Chi_data'));
Chidata.Trange{1} = [1, 40];

if strcmp(ModelConf.g_def, 'dir')
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
setting.res_save = 2;   % 0 -> off, 1 -> save the best, 2 -> save all

% The file name to save intermediate results.
setting.res_save_name = 'EDtest';


% =========================================================================

mkdir(['tmp_', TStr]);
if setting.res_save ~= 0
    mkdir([setting.res_save_name, '_', TStr])
end
save(['tmp_', TStr, '/exp_data.mat'], 'Cmdata', 'Chidata');
save(['tmp_', TStr, '/configuration.mat'], 'Geo', 'conf', 'ModelConf', 'setting', 'lossconfig')
% =========================================================================
opt_func(TStr)
