function [ Intr ] = IntrcMap_XXZtest( Para )
% Triangular lattice
% Transverse field Ising model
% Parameter:
%           J1     Nearest neighbor term
%           J2     Next-nearest neighbor term
%           Delta  Transverse field term
%
% Hamiltonian:
%   H = J1 \sum_<i,j> Sz_i Sz_j
%       + J2 \sum_<<i,j>> Sz_i Sz_j
%       - Delta\sum_i Sx_i
%       - hz\sum_i Sz_i
L = Para.Geo.L;
if isinf(L)
    error('Illegal lattice sites!')
end
int_num = 3 * (L-1);
BC = Para.Geo.BC;

if strcmp(BC, 'PBC')
    int_num = int_num + 3;
end
int_cell = cell(int_num, 5);
count = 1;

% OBC part

for x = 1:1:(L-1)
    
    int_cell{count, 1} = x;
    int_cell{count, 2} = x + 1;
    int_cell{count, 3} = 'Sx';
    int_cell{count, 4} = 'Sx';
    int_cell{count, 5} = Para.Model.Jxy;
    count = count + 1;
    
    int_cell{count, 1} = x;
    int_cell{count, 2} = x + 1;
    int_cell{count, 3} = 'Sy';
    int_cell{count, 4} = 'Sy';
    int_cell{count, 5} = Para.Model.Jxy;
    count = count + 1;
    
    int_cell{count, 1} = x;
    int_cell{count, 2} = x + 1;
    int_cell{count, 3} = 'Sz';
    int_cell{count, 4} = 'Sz';
    int_cell{count, 5} = Para.Model.Jz;
    
    count = count + 1;
end

if strcmp(BC, 'PBC')
    int_cell{count, 1} = 1;
    int_cell{count, 2} = L;
    int_cell{count, 3} = 'Sx';
    int_cell{count, 4} = 'Sx';
    int_cell{count, 5} = Para.Model.Jxy;
    count = count + 1;
    
    int_cell{count, 1} = 1;
    int_cell{count, 2} = L;
    int_cell{count, 3} = 'Sy';
    int_cell{count, 4} = 'Sy';
    int_cell{count, 5} = Para.Model.Jxy;
    count = count + 1;
    
    int_cell{count, 1} = 1;
    int_cell{count, 2} = L;
    int_cell{count, 3} = 'Sz';
    int_cell{count, 4} = 'Sz';
    int_cell{count, 5} = Para.Model.Jz;
    
    count = count + 1;
end

Intr = struct('JmpOut', int_cell(:,1), 'JmpIn', int_cell(:,2), ...
              'JmpOut_type', int_cell(:,3), 'JmpIn_type', int_cell(:,4), 'CS', int_cell(:,5));

for i = 1:1:length(Intr)
    if Intr(i).JmpOut > Intr(i).JmpIn
        T = Intr(i).JmpIn;
        Intr(i).JmpIn = Intr(i).JmpOut;
        Intr(i).JmpOut = T;
    end
end
end