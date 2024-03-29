function [ RG_Rslt ] = GetXTRGRslt( Para )

RG_Rslt.LnZ = [ ];
RG_Rslt.Cm = [ ];
RG_Rslt.M = [ ];
RG_Rslt.En = [ ];
RG_Rslt.beta = [ ];
RG_Rslt.EE = { };
[H, Id, Op] = InitHam(Para);

global EVO_check
if EVO_check == 1
    fprintf('Get the Hamiltonian!\n')
end
switch Para.ThDQ
    case 'Cm'
        ST_l = [0,1,2,3];
    case 'Chi'
        ST_l = [0,2];
    otherwise
        ST_l = [0,1,2,3];
end

RunParallelmaxNumCompThreads = Para.RunParallelmaxNumCompThreads;
if Para.Parallel && Para.RunParallel
    Rslt = cell(length(ST_l), 1);
    parfor(i = 1:length(ST_l), Para.RunParallelNum)
        maxNumCompThreads(RunParallelmaxNumCompThreads);
        ST = ST_l(i);
        Rslt{i} = XTRG_Main( Para, H, Id, Op, ST, i );
    end
else
    Rslt = cell(length(ST_l), 1);
    for i = 1:1:length(ST_l)
        ST = ST_l(i);
        Rslt{i} = XTRG_Main( Para, H, Id, Op, ST, 0 );
    end
end
for i = 1:1:length(ST_l)
    RG_Rslt.beta = [RG_Rslt.beta; Rslt{i}.beta];
    RG_Rslt.LnZ = [RG_Rslt.LnZ; Rslt{i}.LnZ];
    RG_Rslt.Cm = [RG_Rslt.Cm; Rslt{i}.Cm];
    RG_Rslt.M = [RG_Rslt.M; Rslt{i}.M];
    RG_Rslt.En = [RG_Rslt.En; Rslt{i}.En];
    RG_Rslt.EE = [RG_Rslt.EE, Rslt{i}.EE];
end
RG_Rslt = sort_beta(RG_Rslt);
[RG_Rslt.CCHA, RG_Rslt.betaCHA] = ThDQ_func( RG_Rslt , Para);
RG_Rslt.beta_ori = RG_Rslt.beta;
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
        
        %==
        T = Rslt.EE(i);
        Rslt.EE(i) = Rslt.EE(i+1);
        Rslt.EE(i+1) = T;
        i = 0;
    end
    i = i + 1;
end
end
