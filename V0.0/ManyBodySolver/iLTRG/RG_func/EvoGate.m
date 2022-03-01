function [ Uab, Uba ] = EvoGate( Hab, Hba, Para )
% function [ Uab, Uba ] = EvoGate( Hab, Hba, Para );
Uab = expm(-Para.tau * Hab);
Uba = expm(-Para.tau * Hba);
end

