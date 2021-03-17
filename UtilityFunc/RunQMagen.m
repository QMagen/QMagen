function RunQMagen(QMagenConf, varargin)

addpath('lossfunc')
addpath('ManyBodySolver')
addpath('UtilityFunc')
addpath (genpath('SpinModel'))
addpath ('Class')

TStr = datestr(now,'YYYYmmDD_HHMMSS');

switch QMagenConf.Config.Mode
    case 'OPT' 
        mkdir(['tmp_', TStr]);
        
        if QMagenConf.Setting.SAVEFLAG ~= 0
            mkdir([Setting.SAVENAME, '_', TStr])
        end
        QMagenConf.Config.TStr = TStr;
        save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        opt_func(TStr)
    case {'LOSS', 'CACL-Cm', 'CALC-Chi'}
end
end