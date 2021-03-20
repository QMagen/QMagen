function [ Rslt ] = GetiLTRGRslt( Para, ThDQ )

LnZ_l = iTEBD(Para);
[Rslt.beta, Rslt.T] = Tem_cal(Para);

if strcmp(ThDQ, 'Cm') || strcmp(ThDQ, 'Cm&Chi')
    Rslt.Cm = Cm_cal(LnZ_l, Rslt.beta, Para);
    Rslt.Cm = Rslt.Cm(2:1:(end-1));
else
    Rslt.Cm = 0;
end

if norm(Para.Field.h) ~= 0 && (strcmp(ThDQ, 'Chi') || strcmp(ThDQ, 'Cm&Chi'))
    
    delta_h = 0.025;
    
    Para.Field.h = Para.Field.h + delta_h * Para.Field.h / norm(Para.Field.h);
    LnZ_l_u = iTEBD(Para);
    Para.Field.h = Para.Field.h - 2 * delta_h * Para.Field.h / norm(Para.Field.h);
    LnZ_l_d = iTEBD(Para);
    
    Rslt.M = M_cal(LnZ_l_u, LnZ_l_d, Rslt.beta, delta_h, Para);
    Rslt.M = Rslt.M(2:1:(end-1));
else
    Rslt.M = 0;
end
Rslt.beta = Rslt.beta(2:1:(end-1));
Rslt.T = Rslt.T(2:1:(end-1));
end

