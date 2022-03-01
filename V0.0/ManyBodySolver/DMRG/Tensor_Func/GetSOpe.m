function [O1, O2] = GetSOpe( Op, Para )


switch Para.O1_type
    case 'Sx'
        O1n = Op.Sx;
    case 'Sy'
        O1n = Op.Sy;
    case 'Sz'
        O1n = Op.Sz;
end

switch Para.O2_type
    case 'Sx'
        O2n = Op.Sx;
    case 'Sy'
        O2n = Op.Sy;
    case 'Sz'
        O2n = Op.Sz;
end

switch Para.Furi_type
    case 'OBC'
        ft = sin((1:1:Para.L) * Para.q) .* sqrt(2/(Para.L + 1));
        O1 = GetAMMPO(Para.L, Op.Id, O1n, ft);
        O2 = GetAMMPO(Para.L, Op.Id, O2n, ft);
    case 'PBC'
        keyboard;
    otherwise
        keyboard;
end
end

function [ MPO ] = GetAMMPO( L, Id, S0, ft)
d = length(Id(:,1));
MPO.A = cell(L, 1);
for i = 1:1:L
    S = S0 * ft(i);
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
MPO.lgnorm = 0;
end