function [ H, M ] = ED_Hamiltonian( Para, IntrcMap )

d = Para.d;  L = Para.L;           
[Sx, Sy, Sz, Id] = SpinOp(d);

% \\ init Spin operators and Sxtot, Sytot, Sztot;
SxP = cell(L,1);  SyP = cell(L,1);  SzP = cell(L,1);
Sxtot = 0;        Sytot = 0;        Sztot = 0;
for i = 1:1:L
    SxP{i} = DirectProd(Sx, i, L, Id);
    SyP{i} = DirectProd(Sy, i, L, Id);
    SzP{i} = DirectProd(Sz, i, L, Id);
    Sxtot = Sxtot + SxP{i};
    Sytot = Sytot + SyP{i};
    Sztot = Sztot + SzP{i};
end

% \\ coupling
H = 0;
for i = 1:1:length(IntrcMap)
    
    switch IntrcMap(i).JmpOut_type
        case 'Sx'
            S1 = SxP{IntrcMap(i).JmpOut};
        case 'Sy'
            S1 = SyP{IntrcMap(i).JmpOut};
        case 'Sz'
            S1 = SzP{IntrcMap(i).JmpOut};
        case 'OnSite'
            S1 = 1;
    end
    
    switch IntrcMap(i).JmpIn_type
        case 'Sx'
            S2 = SxP{IntrcMap(i).JmpIn};
        case 'Sy'
            S2 = SyP{IntrcMap(i).JmpIn};
        case 'Sz'
            S2 = SzP{IntrcMap(i).JmpIn};
    end
    H = H + IntrcMap(i).CS * S1 * S2;
end

% \\ field
h = Para.Field.h;
hp = h/norm(h);
H = H - h(1) * Sxtot - h(2) * Sytot - h(3) * Sztot;
M = hp(1) * Sxtot + hp(2) * Sytot + hp(3) * Sztot;
end

% ============================================================
% sub-function
% ============================================================

function SP = DirectProd(S, i, L, Id)
% calculate spin operators in the direct-product space
SP = S;
for si = 1:1:L
    if si < i
        SP = kron(SP, Id);     % sites before i (Spin Op resides)
    elseif si > i
        SP = kron(Id, SP);     % sites after i
    end
end
end