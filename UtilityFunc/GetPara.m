function [ Para ] = GetPara( Model, Field, K_min )
% function [Para] = GetPara(Model, Field, K_min)
% Set the parameter of the problem.

load(['tmp_', Model.TStr, '/configuration.mat'])

Para.many_body_solver = Conf.many_body_solver;   

if ismember(Conf.many_body_solver, {'ED', 'XTRG'})
    Para.IntrcMap_Name = Conf.IntrcMap_Name;
elseif ismember(Conf.many_body_solver, {'iLTRG'})
    Para.Trotter_Name = Conf.Trotter_Name;
end
Para.d = Conf.d;
Para.L = Conf.L;
Para.Geo = GeomConf;

% ====================================================

global plot_check
plot_check = setting.plot_check; 

global EVO_check
EVO_check = setting.EVO_check;  

global res_save
res_save = setting.res_save;  

global res_save_name
res_save_name = [setting.res_save_name, '_', Model.TStr, '/'];

global save_count
if isempty(save_count)
    save_count = 1;
end

global min_loss_val
if isempty(min_loss_val)
    min_loss_val = Inf;
end

Para.Model = Model;
Para.Field = Field;
Para.UnitCon = GetUnitCon(Para);
Para.tau = 0.0025;   % default
Para.beta_max = 1 / (K_min / Para.UnitCon.T_con);

try
    Para.Field.h = Para.Field.h*1;
catch
    Para.Field.h = Para.Field.B ./ Para.UnitCon.h_con;
end
end