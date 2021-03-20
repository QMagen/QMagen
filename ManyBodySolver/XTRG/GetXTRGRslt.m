function [ RG_Rslt ] = GetXTRGRslt( Para )

RG_Rslt.LnZ = [ ];
RG_Rslt.Cm = [ ];
RG_Rslt.M = [ ];
RG_Rslt.En = [ ];
RG_Rslt.beta = [ ];

[H, Id, Op] = InitHam(Para);
global EVO_check
if EVO_check == 1
    fprintf('Get the Hamiltonian!\n')
end
ST_l = [0,1,2,3];
% parpool(4);
Rslt = cell(4,1);
parfor (i = 1:1:length(ST_l), 4)
    maxNumCompThreads(1);
    ST = ST_l(i);
    Rslt{i} = XTRG_Main( Para, H, Id, Op, ST );
end

for i = 1:1:length(ST_l)
    RG_Rslt.beta = [RG_Rslt.beta; Rslt{i}.beta];
    RG_Rslt.LnZ = [RG_Rslt.LnZ; Rslt{i}.LnZ];
    RG_Rslt.Cm = [RG_Rslt.Cm; Rslt{i}.Cm];
    RG_Rslt.M = [RG_Rslt.M; Rslt{i}.M];
    RG_Rslt.En = [RG_Rslt.En; Rslt{i}.En];
end
RG_Rslt = sort_beta(RG_Rslt);
[RG_Rslt.CCHA, RG_Rslt.betaCHA] = ThDQ_func( RG_Rslt , Para);
end

function [ Rslt ] = sort_beta( Rslt )
i = 1;
len = length(Rslt.beta);
while i < len-1
    if Rslt.beta(i) > Rslt.beta(i+1)
        %==
        T = Rslt.beta(i);
        Rslt.beta(i) = Rslt.beta(i+1);
        Rslt.beta(i+1) = T;
        
        %==
        T = Rslt.LnZ(i);
        Rslt.LnZ(i) = Rslt.LnZ(i+1);
        Rslt.LnZ(i+1) = T;
        
        %==
        T = Rslt.Cm(i);
        Rslt.Cm(i) = Rslt.Cm(i+1);
        Rslt.Cm(i+1) = T;
        
        %==
        T = Rslt.M(i);
        Rslt.M(i) = Rslt.M(i+1);
        Rslt.M(i+1) = T;
        
        %==
        T = Rslt.En(i);
        Rslt.En(i) = Rslt.En(i+1);
        Rslt.En(i+1) = T;
        
        i = 0;
    end
    i = i + 1;
end
end
