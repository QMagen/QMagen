function [ ED_Rslt ] = GetEDCRslt( Para, ThDQ )

% =========================================================================
% fprintf('Get Ham:')
InMap = eval([Para.IntrcMap_Name, '(Para)']);
[H, M] = GetHamCpp(Para, InMap);

% =========================================================================
% keyboard;
beta_list = Para.beta_list;

switch ThDQ
    case 'Cm'
        
        [T, C, E] = ED_Cm(H, beta_list);
        C = C ./ Para.L;
        ED_Rslt.T = T;
        ED_Rslt.beta = 1./T;
        ED_Rslt.Cm = C;
        ED_Rslt.M = 0;
        ED_Rslt.En = E ./ Para.L;
        
    case 'Chi'

        [T, M, ~] = ED_chi(H, M, norm(Para.Field.h), beta_list);
        M = M ./ Para.L;
        ED_Rslt.T = T;
        ED_Rslt.beta = 1./T;
        ED_Rslt.M = M;
        ED_Rslt.Cm = 0;

end

end

