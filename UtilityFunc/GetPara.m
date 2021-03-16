function [ Para ] = GetPara( Model, Field, K_min )
% function [Para] = GetPara(Model, Field, K_min)
% Set the parameter of the problem.

load(['tmp_', Model.TStr, '/configuration.mat'])

Para.ManyBodySolver = QMagenConf.Config.ManyBodySolver;   

if ismember(Para.ManyBodySolver, {'ED', 'XTRG'})
    Para.IntrcMap_Name = QMagenConf.Model.IntrcMap;
elseif ismember(Para.ManyBodySolver, {'iLTRG'})
    Para.Trotter_Name = QMagenConf.Model.Trotter;
end
Para.d = eval(QMagenConf.Model.LocalSpin) * 2 + 1;
Para.L = QMagenConf.Lattice.L;
Para.Geo = QMagenConf.Lattice;

% ====================================================

global PLOTFLAG
PLOTFLAG = QMagenConf.Setting.PLOTFLAG; 

global EVOFLAG
EVOFLAG = QMagenConf.Setting.EVOFLAG;  

global SAVEFLAG
SAVEFLAG = QMagenConf.Setting.SAVEFLAG;  

global SAVENAME
SAVENAME = [QMagenConf.Setting.SAVENAME, '_', Model.TStr, '/'];

global SAVE_COUNT
if isempty(SAVE_COUNT)
    SAVE_COUNT = 1;
end

global MIN_LOSS_VAL
if isempty(MIN_LOSS_VAL)
    MIN_LOSS_VAL = Inf;
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