function [ ED_Rslt ] = GetEDRslt( Para, ThDQ )
InMap = eval([Para.IntrcMap_name, '(Para)']);
[H, M] = ED_Hamiltonian(Para, InMap);
betaCHA = 0.0025.*2.^(0:1:15).*2^0.1;
for int = 0.3:0.2:0.9
    betaCHA = [betaCHA, 0.0025.*2.^(0:1:15).*2^int];
end
beta_list = sort(betaCHA);
switch ThDQ
    case 'Cm'
        [T, C] = ED_Cm(H, beta_list);
        C = C ./ Para.L;
        ED_Rslt.T = T;
        ED_Rslt.beta = 1./T;
        ED_Rslt.Cm = C;
        ED_Rslt.M = 0;
    case 'Chi'
        [T, M, ~] = ED_chi(H, M, norm(Para.Field.h), beta_list);
        M = M ./ Para.L;
        ED_Rslt.T = T;
        ED_Rslt.beta = 1./T;
        ED_Rslt.M = M;
        ED_Rslt.Cm = 0;
end
end

