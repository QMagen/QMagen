function [ Ope ] = AssignATensor1Site( Op, Id, Para )
% function [ H ] = AssignATensor1Site( H, Op, IntrInfo, Para )
L = Para.L;

Sxtot = Id;
Sxtot.A{1} = Op.Sx3;
Sytot = Id;
Sytot.A{1} = Op.Sy3;
Sztot = Id;
Sztot.A{1} = Op.Sz3;
Hh = Id;
Hh.A{1} = Para.Field.h(1) * Op.Sx3 + Para.Field.h(2) * Op.Sy3 + Para.Field.h(3) * Op.Sz3;
if norm(Para.Field.h) ~= 0
    Sm = Id;
    Sm.A{1} = Hh.A{1} / norm(Para.Field.h);
end

for i = 2:1:(L-1)
    Sx = Id;
    Sx.A{i} = Op.Sx4;
    Sxtot.A = DircSumMPO(Sxtot.A, Sx.A);
    
    Sy = Id;
    Sy.A{i} = Op.Sy4;
    Sytot.A = DircSumMPO(Sytot.A, Sy.A);
    
    Sz = Id;
    Sz.A{i} = Op.Sz4;
    Sztot.A = DircSumMPO(Sztot.A, Sz.A);
    
    h = Id;
    h.A{i} = Para.Field.h(1) * Op.Sx4 + Para.Field.h(2) * Op.Sy4 + Para.Field.h(3) * Op.Sz4;
    Hh.A = DircSumMPO(Hh.A, h.A);
    
    if norm(Para.Field.h) ~= 0
        h.A{i} = h.A{i} / norm(Para.Field.h);
        Sm.A = DircSumMPO(Sm.A, h.A);
    end
    
end

Sx = Id;
Sx.A{end} = Op.Sx3;
Sxtot.A = DircSumMPO(Sxtot.A, Sx.A);

Sy = Id;
Sy.A{end} = Op.Sy3;
Sytot.A = DircSumMPO(Sytot.A, Sy.A);

Sz = Id;
Sz.A{end} = Op.Sz3;
Sztot.A = DircSumMPO(Sztot.A, Sz.A);

h = Id;
h.A{end} = Para.Field.h(1) * Op.Sx3 + Para.Field.h(2) * Op.Sy3 + Para.Field.h(3) * Op.Sz3;
Hh.A = DircSumMPO(Hh.A, h.A);

if norm(Para.Field.h) ~= 0
    h.A{end} = h.A{end} / norm(Para.Field.h);
    Sm.A = DircSumMPO(Sm.A, h.A);
end

Ope.Sxtot = Sxtot;
Ope.Sytot = Sytot;
Ope.Sztot = Sztot;
Ope.Hh = Hh;

if norm(Para.Field.h) ~= 0
    Ope.Sm = Sm;
end

end

