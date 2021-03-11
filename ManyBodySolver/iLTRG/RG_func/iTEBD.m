function [ LnZ ] = iTEBD( Para )
% function [ LnZ ] = iTEBD( Para )

LnZ = zeros(Para.N_max, 1);
lgnorm = 0;

[Ta, Tb, La, Lb] = InitId(Para);
[Hab, Hba] = InitHam_trotter(Para);
[Uab, Uba] = EvoGate(Hab, Hba, Para);

for It = 1:1:Para.N_max
    [Ta, Lb, Tb, Ns] = EvoRG(La, Ta, Lb, Tb, Uab, Para);
    lgnorm = lgnorm + log(Ns);
    [Tb, La, Ta, Ns] = EvoRG(Lb, Tb, La, Ta, Uba, Para);
    lgnorm = lgnorm + log(Ns);
    maxeig = BilayerTrace(Ta, La, Tb, Lb);
    LnZ(It) = lgnorm + log(maxeig)/2;
end
 

end

