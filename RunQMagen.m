clear all
addpath lossfunc
addpath ManyBodySolver
addpath Config

TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
Conf.many_body_solver = 'XTRG'; % 'ED', 'LTRG', 'XTRG'         % conf, BC, Mar13

%if strcmp(Conf.many_body_solver, 'ED') || strcmp(Conf.many_body_solver, 'XTRG')
if ismember(Conf.many_body_solver, {'ED', 'XTRG'})
    Conf.IntrcMap_Name = 'IntrcMap_TLTI';
elseif ismember(Conf.many_body_solver, {'iLTRG'})
    Conf.Trotter_Name = 'Tortter_AAFHC';
end

Conf.d = 2;
Conf.L = 9;

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
GeomConf.Lx = 3;                                   % Geo, BC, Mar13
GeomConf.Ly = 3;
GeomConf.BCX = 'OBC';
GeomConf.BCY = 'PBC';

ModelConf.Para_List = {'J1', 'J2', 'Delta'};        % Para, BC, Mar13
ModelConf.Para_Range = {[5, 20], [0, 5], [0, 12]};  % Para_opt_range, BC, Mar13

ModelConf.Num_gFactor = 1;                           % g_len, BC, Mar13
ModelConf.Type_gFactor = 'xyz'; % 'xyz', 'dir'       % g_def, BC, Mar13

ModelConf.gFactor = cell(ModelConf.Num_gFactor, 1);       % g, BC, Mar13
ModelConf.gFactor_Vec = cell(ModelConf.Num_gFactor, 1);   % g_vec, BC, Mar13
ModelConf.gFacotr_Range = cell(ModelConf.Num_gFactor, 1); % g_opt_range, BC, Mar13

ModelConf.gFactor{1} = 'gz';
ModelConf.gFactor_Vec{1} = [0,0,1];
ModelConf.gFacotr_Range{1} = [5, 20]; 


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
