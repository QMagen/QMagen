function [ varargout ] = QMagenMain(QMagenConf, varargin)
% -------------------------------------------------
% Usage: 
%       QMagenMain(QMagenConf)
%       [LOSS] = QMagenConf(QMagenConf)
%       [Rslt_NU, Rslt_EXP] = QMagenConf(QMagenConf, 'Kmin', lowest set temperature)
% -------------------------------------------------
addpath('lossfunc')
addpath('ManyBodySolver')
addpath('UtilityFunc')
addpath (genpath('SpinModel'))
addpath ('Class')

TStr = datestr(now,'YYYYmmDD_HHMMSS');

display(QMagenConf)

switch QMagenConf.Config.Mode
    case 'OPT' 
        mkdir(['tmp_', TStr]);
        
        if QMagenConf.Setting.SAVEFLAG ~= 0
            mkdir([QMagenConf.Setting.SAVENAME, '_', TStr])
        end
        QMagenConf.Config.TStr = TStr;
        save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        opt_func(TStr)
    case 'LOSS'
        mkdir(['tmp_', TStr]);
        
        if QMagenConf.Setting.SAVEFLAG ~= 0
            mkdir([QMagenConf.Setting.SAVENAME, '_', TStr])
        end
        QMagenConf.Config.TStr = TStr;
        save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        loss = zeros(length(varargin{2}), 1);
        for loop_num = 1:1:length(varargin{2})
            ParaVal = zeros(1, length(QMagenConf.ModelConf.Para_Name));
            for i = 1:1:length(ParaVal)
                pos = find(strcmp(varargin, QMagenConf.ModelConf.Para_Name{i}), 1) + 1;
                ParaVal(i) = varargin{pos}(loop_num);
            end
            
            g = zeros(1, QMagenConf.ModelConf.gFactor_Num);
            for i = 1:1:length(g)
                pos = find(strcmp(varargin, QMagenConf.ModelConf.gFactor_Name{i}), 1) + 1;
                g(i) = varargin{pos}(loop_num);
            end
            loss(loop_num) = loss_func( TStr, g, ParaVal );
        end
        varargout{1} = loss;
    case 'CALC-Cm'
%         mkdir(['tmp_', TStr]);
%         
%         QMagenConf.Config.TStr = TStr;
%         save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        
        [Rslt, ~] = GetResult(QMagenConf, varargin{2}, 'Cm');
        pos = find(Rslt.T < varargin{2});
        pos = pos(1) + 1;
        Rslt1.T = Rslt.T(1:1:pos);
        Rslt1.Cm = Rslt.Cm(1:1:pos);
        varargout{1} = Rslt1;
%         varargout{2} = Rslt_exp;
%         save(['tmp_', TStr, '/Rslt.mat'], 'Rslt', 'Rslt_exp');
    case 'CALC-Chi'
%         mkdir(['tmp_', TStr]);
%         
%         QMagenConf.Config.TStr = TStr;
%         save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        
        [Rslt, ~] = GetResult(QMagenConf, varargin{2}, 'Chi');
        pos = find(Rslt.T < varargin{2});
        pos = pos(1) + 1;
        Rslt1.T = Rslt.T(1:1:pos);
        Rslt1.Chi = Rslt.M(1:1:pos) ./ norm(QMagenConf.Field.h);
        varargout{1} = Rslt1;
%         varargout{2} = Rslt_exp;
%         save(['tmp_', TStr, '/Rslt.mat'], 'Rslt', 'Rslt_exp');
end
end