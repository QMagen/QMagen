function [Rslt, Rslt_exp_unit] = GetResult(QMagenConf, K_min, ThDQ)
Para = GetPara(QMagenConf, K_min);

switch Para.ManyBodySolver
    case {'ED'}
        addpath(genpath('../ManyBodySolver/ED'));
        
        Rslt = GetEDRslt(Para, ThDQ);
        
        rmpath(genpath('../ManyBodySolver/ED'));
    case {'XTRG'}
        addpath(genpath('../ManyBodySolver/XTRG'));
        
        Rslt = GetXTRGRslt(Para);
        
        rmpath(genpath('../ManyBodySolver/XTRG'));
    case {'iLTRG'}
        addpath(genpath('../ManyBodySolver/iLTRG'));
        
        Rslt = GetiLTRGRslt(Para, ThDQ);
        
        rmpath(genpath('../ManyBodySolver/iLTRG'));
    otherwise
        fprintf('Illegal mant-body solver! \n');
        keyboard;
end
if strcmp(ThDQ, 'Cm') && strcmp(Para.ManyBodySolver, 'XTRG')
    Rslt.beta = Rslt.betaCHA;
    Rslt.Cm = Rslt.CCHA;
end
Rslt_exp_unit.T_l = 1 ./ Rslt.beta * Para.UnitCon.T_con;
Rslt_exp_unit.Cm_l = real(Rslt.Cm) * Para.UnitCon.Cm_con;
if norm(Para.Field.h) ~= 0
    try 
        geff = sqrt(sum((Para.Field.B .* Para.Model.g).^2))/norm(Para.Field.B);
    catch
        geff = 2;
    end
    Rslt_exp_unit.Chi_l = real(Rslt.M) ./ norm(Para.Field.h) .* Para.UnitCon.Chi_con * geff^2; 
end
end