function [ ED_Rslt ] = GetEDRslt( Para, ThDQ )

Op = GetLocalSpace(Para.d);
H = AutomataInit(Para);
[H, Ope] = AutomataInit1Site(H, Op, Para);
% [H.A, lgnorm] = CompressH(H.A);
% H.lgnorm = H.lgnorm + lgnorm;
% keyboard;
H = MPO2H(H.A) * exp(H.lgnorm);
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
        
%         [T, C, E] = ED_Cm(HMPO, beta_list);
%         C = C ./ Para.L;
%         MPO_Rslt.T = T;
%         MPO_Rslt.beta = 1./T;
%         MPO_Rslt.Cm = C;
%         MPO_Rslt.M = 0;
%         MPO_Rslt.En = E ./ Para.L;
%         
%         [T, C, E] = ED_Cm(HMPOC, beta_list);
%         C = C ./ Para.L;
%         MPOC_Rslt.T = T;
%         MPOC_Rslt.beta = 1./T;
%         MPOC_Rslt.Cm = C;
%         MPOC_Rslt.M = 0;
%         MPOC_Rslt.En = E ./ Para.L;
%         
%         save('test_Rslt.mat', 'ED_Rslt', 'MPO_Rslt', 'MPOC_Rslt');
    case 'Chi'

        M = MPO2H(Ope.Sm.A);
        [T, M, ~] = ED_chi(H, M, norm(Para.Field.h), beta_list);
        M = M ./ Para.L;
        ED_Rslt.T = T;
        ED_Rslt.beta = 1./T;
        ED_Rslt.M = M;
        ED_Rslt.Cm = 0;
        
%         [T, E, M] = ED_M(H, M, norm(Para.Field.h), beta_list);
%         ED_Rslt.T = T;
%         ED_Rslt.E = E;
%         ED_Rslt.M = M;
end

end

