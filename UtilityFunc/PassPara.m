function [ Para ] = PassPara( QMagenConf, K_min )
% function [Para] = GetPara(Model, Field, K_min)
% Set the parameter of the problem.


Para.ManyBodySolver = QMagenConf.Config.ManyBodySolver; 
Para.TStr = QMagenConf.Config.TStr;
% //pass interaction map (ED, XTRG) or Trotter gates (iLTRG) to solvers
try
    Para.IntrcMap_Name = QMagenConf.ModelConf.IntrcMap;
end
try
    Para.Trotter_Name = QMagenConf.ModelConf.Trotter;
end

Para.d = eval(QMagenConf.ModelConf.LocalSpin) * 2 + 1;
Para.L = QMagenConf.Lattice.L;
Para.Geo = QMagenConf.Lattice;

if strcmp(QMagenConf.Config.Mode, 'LOSS') && strcmp(QMagenConf.Config.ManyBodySolver, 'XTRG')
    Para.Parallel = true;
else
    Para.Parallel = false;
end
% ====================================================
switch QMagenConf.Config.Mode
    case {'OPT', 'LOSS', 'ThDQ'}
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

% //Common parameters for many-body solvers: iLTRG, XTRG, ED, etc.
Para.Model = QMagenConf.ModelParaValue;
Para.Field = QMagenConf.Field;
Para.UnitCon = GetUnitCon(Para);
Para.beta_max = 1 / (K_min / Para.UnitCon.T_con);
[ Para ] = GetField( Para );

% //Import runtime parameters for each solver
Para = ImportMBSolverPara( Para );

end