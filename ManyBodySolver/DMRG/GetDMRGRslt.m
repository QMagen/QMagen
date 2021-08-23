function [T, E0, M] = GetDMRGRslt(Para)

[ H, Id, Ope ] = InitHam(Para);

% Get ground state & ground state energy
[T, E0] = DMRGMain(Para, H);
if norm(Para.Field.h) ~= 0
    M = Observe( T, Ope.Sm, Para )/Para.L;
else
    M = 0;
end

end

