function [ varargout ] = QMagenMain(QMagenConf, varargin)
% -------------------------------------------------
% Usage: 
%       QMagenMain(QMagenConf)
%       [LOSS] = QMagenConf(QMagenConf)
%       [Rslt_NU, Rslt_EXP] = QMagenConf(QMagenConf, 'Kmin', lowest set temperature)
% -------------------------------------------------

TStr = datestr(now,'YYYYmmDD_HHMMSS');
if ~exist('../Tmp','dir')
	mkdir('../Tmp');
end

switch QMagenConf.Config.Mode
    case 'OPT' 
        display(QMagenConf)
        mkdir(['../Tmp/tmp_', TStr]);
        
        if QMagenConf.Setting.SAVEFLAG ~= 0
            mkdir(['../Tmp/', QMagenConf.Setting.SAVENAME, '_', TStr])
        end
        QMagenConf.Config.TStr = TStr;
        save(['../Tmp/tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        OptFunc(TStr, QMagenConf)
        
    case 'LOSS'
        mkdir(['../Tmp/tmp_', TStr]);
        
        if QMagenConf.Setting.SAVEFLAG ~= 0
            mkdir(['../Tmp/', QMagenConf.Setting.SAVENAME, '_', TStr])
        end
        QMagenConf.Config.TStr = TStr;
        save(['../Tmp/tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        loss = zeros(length(varargin{2}), 1);
        for loop_num = 1:1:length(varargin{2})
            ParaVal = zeros(1, length(QMagenConf.ModelConf.Para_Name));
            for i = 1:1:length(ParaVal)
                pos = find(strcmp(varargin, QMagenConf.ModelConf.Para_Name{i}), 1) + 1;
                try
                    ParaVal(i) = varargin{pos}(loop_num);
                catch
                    error('Not enough input arguemet! The value of %s is required!', ...
                            QMagenConf.ModelConf.Para_Name{i})
                end
            end
            
            g = zeros(1, QMagenConf.ModelConf.gFactor_Num);
            for i = 1:1:length(g)
                pos = find(strcmp(varargin, QMagenConf.ModelConf.gFactor_Name{i}), 1) + 1;
                try
                    g(i) = varargin{pos}(loop_num);
                catch
                    error('Not enough input arguemet! The value of %s is required!', ...
                            QMagenConf.ModelConf.gFactor_Name{i})
                end
            end
            loss(loop_num) = loss_func( TStr, g, ParaVal );
        end
        varargout{1} = loss;
    case 'ThDQ'
        mkdir(['../Tmp/tmp_', TStr]);
        
        if QMagenConf.Setting.SAVEFLAG ~= 0
            mkdir(['../Tmp/', QMagenConf.Setting.SAVENAME, '_', TStr])
        end
        QMagenConf.Config.TStr = TStr;
        save(['../Tmp/tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        RsltCvNU = cell(length(varargin{2}), 1);
        RsltCv = cell(length(varargin{2}), 1);
        RsltChiNU = cell(length(varargin{2}), 1);
        RsltChi = cell(length(varargin{2}), 1);
        
        for loop_num = 1:1:length(varargin{2})
            ParaVal = zeros(1, length(QMagenConf.ModelConf.Para_Name));
            for i = 1:1:length(ParaVal)
                pos = find(strcmp(varargin, QMagenConf.ModelConf.Para_Name{i}), 1) + 1;
                try
                    ParaVal(i) = varargin{pos}(loop_num);
                catch
                    error('Not enough input arguemet! The value of %s is required!', ...
                            QMagenConf.ModelConf.Para_Name{i})
                end
            end
            
            g = zeros(1, QMagenConf.ModelConf.gFactor_Num);
            for i = 1:1:length(g)
                pos = find(strcmp(varargin, QMagenConf.ModelConf.gFactor_Name{i}), 1) + 1;
                try
                    g(i) = varargin{pos}(loop_num);
                catch
                    error('Not enough input arguemet! The value of %s is required!', ...
                            QMagenConf.ModelConf.gFactor_Name{i})
                end
            end
            [RsltCvNU{loop_num}, RsltCv{loop_num}, RsltChiNU{loop_num}, RsltChi{loop_num}] = GetThDQRslt( TStr, g, ParaVal );
        end
        varargout{1} = RsltCvNU;
        varargout{2} = RsltCv;
        varargout{3} = RsltChiNU;
        varargout{4} = RsltChi;
    case 'CALC-Cm'
%         mkdir(['tmp_', TStr]);
%         
%         QMagenConf.Config.TStr = TStr;
%         save(['tmp_', TStr, '/configuration.mat'], 'QMagenConf');
        display(QMagenConf)
        [Rslt, ~] = GetResult(QMagenConf, varargin{2}, 'Cm');
        pos = find(Rslt.T < varargin{2});
        pos = pos(1) - 1;
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
        display(QMagenConf)
        [Rslt, ~] = GetResult(QMagenConf, varargin{2}, 'Chi');
        pos = find(Rslt.T < varargin{2});
        pos = pos(1) - 1;
        Rslt1.T = Rslt.T(1:1:pos);
        Rslt1.Chi = Rslt.M(1:1:pos) ./ norm(QMagenConf.Field.h);
        varargout{1} = Rslt1;
%         varargout{2} = Rslt_exp;
%         save(['tmp_', TStr, '/Rslt.mat'], 'Rslt', 'Rslt_exp');
end
end