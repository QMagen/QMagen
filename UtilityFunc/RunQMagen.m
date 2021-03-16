function RunQMagen(QMagenConf)

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
        
        save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        opt_func(TStr)
    case 'LOSS'
    case 'CALC-Cm'
    case 'CALC-Chi'
end
end