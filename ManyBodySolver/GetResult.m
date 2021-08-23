function [Rslt, Rslt_exp_unit] = GetResult(QMagenConf, K_min, ThDQ)

% //set up runtime parameters
Para = PassPara(QMagenConf, K_min);
Para.ThDQ = ThDQ;
addpath('../ManyBodySolver/TensorFunction')
switch Para.ManyBodySolver
    case {'ED'}
        addpath(genpath('../ManyBodySolver/ED'));
        Rslt = GetEDRslt(Para, ThDQ);
        
        rmpath(genpath('../ManyBodySolver/ED'));
        
    case {'ED_C'}
        addpath(genpath('../ManyBodySolver/ED_C'));
        Rslt = GetEDCRslt(Para, ThDQ);
        
        rmpath(genpath('../ManyBodySolver/ED_C'));
        
    case {'XTRG'}
        addpath(genpath('../ManyBodySolver/XTRG'));
        
        Rslt = GetXTRGRslt(Para);
        
        rmpath(genpath('../ManyBodySolver/XTRG'));
        
    case {'iLTRG'}
        addpath(genpath('../ManyBodySolver/iLTRG'));
        
        Rslt = GetiLTRGRslt(Para, ThDQ);
        
        rmpath(genpath('../ManyBodySolver/iLTRG'));
        
    case {'DMRG'}
        addpath(genpath('../ManyBodySolver/DMRG'));
        
        [T, E, M] = GetDMRGRslt(Para);
        
        rmpath(genpath('../ManyBodySolver/DMRG'));
        
    otherwise
        fprintf('Illegal mant-body solver! \n');
        keyboard;
end
if ~strcmp(Para.ManyBodySolver, 'DMRG')
    if strcmp(ThDQ, 'Cm') && (strcmp(Para.ManyBodySolver, 'XTRG') || strcmp(Para.ManyBodySolver, 'XTRG_QS'))
        Rslt.beta = Rslt.betaCHA;
        Rslt.Cm = Rslt.CCHA;
    end
    % keyboard;
    Rslt_exp_unit.T_l = 1 ./ Rslt.beta * Para.UnitCon.T_con;
    Rslt_exp_unit.Cm_l = real(Rslt.Cm) * Para.UnitCon.Cm_con;
    if norm(Para.Field.h) ~= 0
        try
            geff = sqrt(sum((Para.Field.B .* Para.Model.g).^2))/norm(Para.Field.B);
        catch
            geff = 2;
        end
        Rslt_exp_unit.Chi_l = real(Rslt.M) ./ norm(Para.Field.h) .* Para.UnitCon.Chi_con * geff^2;
        Rslt_exp_unit.M = real(Rslt.M);
        % fprintf('%f\n', real(Rslt.M(end-5)));
    end
else
    fprintf('B = [%.2f, %.2f, %.2f], M = %.4f\n', Para.Field.B, M);
    Rslt.T = T;
    Rslt.E = E;
    Rslt.M = M;
    Rslt.B = Para.Field.B;
    
    Rslt_exp_unit = Rslt;
end
end