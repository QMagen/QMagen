function [ maxeig ] = BilayerTraceLTRG( Ta, La, Tb, Lb )
% function [ maxeig ] = BilayerTraceLTRG( Ta, La, Tb, Lb)

T = eye(size(La));
fmaxval = 0;

for It = 1:1:1000
    T = TransM(T, Ta, La);
    T = TransM(T, Tb, Lb);
    
    maxval = max(max(T));
    T = T/maxval;
    
    if abs(maxval-fmaxval) < 1e-9
        break;
    end
    fmaxval = maxval;
end
maxeig = maxval;
end

