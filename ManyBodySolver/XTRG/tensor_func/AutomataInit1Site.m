function [ H, Ope ] = AutomataInit1Site( H, Op, Para )
% function [ H, Ope ] = AutoMataInit1Site( H, Op, Para )
% Initialize the Hamiltonian by Automata picture.
% Yuan Gao@buaa 2021.04.06
% mail: 17231064@buaa.edu.cn
d = Para.d;
L = Para.L;
Sxtot.A = cell(L, 1);
Sxtot.lgnorm = 0;

Sytot.A = cell(L, 1);
Sytot.lgnorm = 0;

Sztot.A = cell(L, 1);
Sztot.lgnorm = 0;

Ope.Sxtot = GetAMMPO(Sxtot, Op.Id, Op.Sx);
Ope.Sytot = GetAMMPO(Sytot, Op.Id, Op.Sy);
Ope.Sztot = GetAMMPO(Sztot, Op.Id, Op.Sz);

h = Para.Field.h;
if norm(Para.Field.h) ~= 0
    hm = h/norm(h);
    Sm.A = cell(Para.L, 1);
    Sm.lgnorm = 0;
    SmOp = hm(1) * Op.Sx + hm(2) * Op.Sy + hm(3) * Op.Sz;
    hOp = - h(1) * Op.Sx - h(2) * Op.Sy - h(3) * Op.Sz;
    Ope.Sm = GetAMMPO(Sm, Op.Id, SmOp);
    
    for i = 1:1:L
        if i == 1
            H.A{i}(end,:,:) = H.A{i}(end,:,:) + reshape(hOp, [1,d,d]);
        elseif i == L
            H.A{i}(1,:,:) = H.A{i}(1,:,:) + reshape(hOp, [1,d,d]);
        else
            H.A{i}(1, end,:,:) = H.A{i}(1, end,:,:) + reshape(hOp, [1,1,d,d]);
        end
    end
end


end

function [ MPO ] = GetAMMPO( MPO, Id, S )
d = length(Id(:,1));
for i = 1:1:length(MPO.A)
    if i == 1
        MPO.A{i} = zeros(1,2,d,d);
        MPO.A{i}(1,1,:,:) = reshape(Id, [1,1,d,d]);
        MPO.A{i}(1,2,:,:) = reshape(S, [1,1,d,d]);
    elseif i == length(MPO.A)
        MPO.A{i} = zeros(2,1,d,d);
        MPO.A{i}(2,1,:,:) = reshape(Id, [1,1,d,d]);
        MPO.A{i}(1,1,:,:) = reshape(S, [1,1,d,d]);
    else
        MPO.A{i} = zeros(2,2,d,d);
        MPO.A{i}(1,1,:,:) = reshape(Id, [1,1,d,d]);
        MPO.A{i}(2,2,:,:) = reshape(Id, [1,1,d,d]);
        MPO.A{i}(1,2,:,:) = reshape(S, [1,1,d,d]);
    end
end
MPO.A{1} = permute(MPO.A{1}, [2,3,4,1]);
MPO.A{end} = permute(MPO.A{end}, [1,3,4,2]);
end









