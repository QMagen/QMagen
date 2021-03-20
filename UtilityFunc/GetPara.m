function [ Para ] = GetPara( QMagenConf, K_min )
% function [Para] = GetPara(Model, Field, K_min)
% Set the parameter of the problem.


Para.ManyBodySolver = QMagenConf.Config.ManyBodySolver;   

if ismember(Para.ManyBodySolver, QMagenConf.ModelConf.AvlbSolver)
    try
        Para.IntrcMap_Name = QMagenConf.ModelConf.IntrcMap;
    catch 
        error('Para.ManyBodySolver not within ModelConf.AvlbSolver!'); pause;
    end
elseif ismember(Para.ManyBodySolver, {'iLTRG'})
    try
        Para.Trotter_Name = QMagenConf.ModelConf.Trotter;
    catch
        error('Config.ManyBodySolver not within ModelConf.AvlbSolver!')
    end
end
Para.d = eval(QMagenConf.ModelConf.LocalSpin) * 2 + 1;
Para.L = QMagenConf.Lattice.L;
Para.Geo = QMagenConf.Lattice;


% ====================================================
switch QMagenConf.Config.Mode
    case {'OPT', 'LOSS'}
        global PLOTFLAG
        PLOTFLAG = QMagenConf.Setting.PLOTFLAG;
        
        global EVOFLAG
        EVOFLAG = 0;
        
        global SAVEFLAG
        SAVEFLAG = QMagenConf.Setting.SAVEFLAG;
        
        global SAVENAME
        SAVENAME = [QMagenConf.Setting.SAVENAME, '_', QMagenConf.Config.TStr, '/'];
        
        global SAVE_COUNT
        if isempty(SAVE_COUNT)
            SAVE_COUNT = 1;
        end
        
        global MIN_LOSS_VAL
        if isempty(MIN_LOSS_VAL)
            MIN_LOSS_VAL = Inf;
        end
    case {'CALC-Cm', 'CALC-Chi'}
end
Para.Model = QMagenConf.ModelParaValue;
Para.Field = QMagenConf.Field;
Para.UnitCon = GetUnitCon(Para);
Para.tau = 0.0025;   % default
Para.beta_max = 1 / (K_min / Para.UnitCon.T_con);

try
    Para.Field.h = Para.Field.h*1;
catch
    Para.Field.h = Para.Field.B ./ Para.UnitCon.h_con;
end
end