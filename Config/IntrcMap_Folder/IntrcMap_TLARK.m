function [ Intr ] = IntrcMap_TLARK( Para )
% Triangular lattice 
% XXZ model
% Parameter: 
%           J1xy        Nearest neighbor SxSx+SySy term
%           J1z         Nearest neighbor SzSz term
%           Jpm         Nearest neighbor gamma_ij S+S+ + h.c.
%           Jpmz        Nearest neighbor gamma_ij* S+Sz - gamma_ij S-Sz + <i<->j>
%           J2xy        Next-nearest neighbor SxSx+SySy term
%           J2z         Next-nearest neighbor SzSz term
%           Delta       Transverse field term
% Hamiltonian:
%   H = \sum_<i,j> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%                  +Jpm (gamma_ij S+_i S+_j + h.c.)
%                  -Jpmz 1i/2 (gamma_ij* S+_i Sz_j - gamma_ij S-_i Sz_j + <i<->j>)
%       + \sum_<<i,j>> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%       - h\sum_i Sh_i
Lx = Para.Geo.Lx;
Ly = Para.Geo.Ly;
L = Lx * Ly;
int_num = 9 * (Lx*(Ly-1)+Ly*(Lx-1)+(Lx-1)*(Ly-1)) + 3 * ((Lx-1)*(Ly-1)+(Ly-2)*(Lx-1)+(Lx-2)*(Ly-1));
BCX = Para.Geo.BCX;
BCY = Para.Geo.BCY;

if strcmp(BCX, 'PBC')
    int_num = int_num + 9 * (Ly + (Ly - 1)) + 3 * ((Ly - 1) + (Ly - 1) + (Ly - 2));
end

if strcmp(BCY, 'PBC')
    int_num = int_num + 9 * (Lx + (Lx - 1)) + 3 * ((Lx - 1) + (Lx - 1) + (Lx - 2));
end
int_num = int_num + L;
int_cell = cell(int_num, 5);
count = 1;
[ Bond_Info ] = Bond_Info_TLARK( Para );

gamma = [1, exp(1i * 2 * pi / 3), exp(-1i * 2 * pi / 3)];
for i = 1:1:length(Bond_Info(:, 1))
    switch Bond_Info{i, 3}
        case {'nn-1', 'nn-2', 'nn-3'}
            tn = str2double(Bond_Info{i, 3}(4));
            for j = 0:1:8
                int_cell{count+j, 1} = Bond_Info{i, 1};
                int_cell{count+j, 2} = Bond_Info{i, 2};
            end
            
            % SxSx
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = Para.Model.J1xy + Para.Model.Jpm * (gamma(tn) + conj(gamma(tn)));
            count = count + 1;
            
            % SySy
            int_cell{count, 3} = 'Sy';
            int_cell{count, 4} = 'Sy';
            int_cell{count, 5} = Para.Model.J1xy - Para.Model.Jpm * (gamma(tn) + conj(gamma(tn)));
            count = count + 1;
            
            % SzSz
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = Para.Model.J1z;
            count = count + 1;
            
            % SxSy
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sy';
            int_cell{count, 5} = 1i * Para.Model.Jpm * (gamma(tn) - conj(gamma(tn)));
            count = count + 1;
            
            % SySx
            int_cell{count, 3} = 'Sy';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = 1i * Para.Model.Jpm * (gamma(tn) - conj(gamma(tn)));
            count = count + 1;
            
            % SxSz
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = 1i/2 * Para.Model.Jpmz * (gamma(tn) - conj(gamma(tn)));
            count = count + 1;
            
            % SzSx
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = 1i/2 * Para.Model.Jpmz * (gamma(tn) - conj(gamma(tn)));
            count = count + 1;
            
            % SySz
            int_cell{count, 3} = 'Sy';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = 1/2 * Para.Model.Jpmz * (gamma(tn) + conj(gamma(tn)));
            count = count + 1;
            
            % SzSy
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sy';
            int_cell{count, 5} = 1/2 * Para.Model.Jpmz * (gamma(tn) + conj(gamma(tn)));
            count = count + 1;
        case {'nnn'}
            for j = 0:1:2
                int_cell{count+j, 1} = Bond_Info{i, 1};
                int_cell{count+j, 2} = Bond_Info{i, 2};
            end
            % SxSx
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = Para.Model.J2xy;
            count = count + 1;
            
            % SySy
            int_cell{count, 3} = 'Sy';
            int_cell{count, 4} = 'Sy';
            int_cell{count, 5} = Para.Model.J2xy;
            count = count + 1;
            
            % SzSz
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = Para.Model.J2z;
            count = count + 1;
    end
end

for i = 1:1:L
    
    int_cell{count, 1} = 0;
    int_cell{count, 2} = i;
    int_cell{count, 3} = 'OnSite';
    int_cell{count, 4} = 'Sx';
    int_cell{count, 5} = -Para.Model.Delta;
    
    count = count + 1;
end

i = 1;
while i <= length(int_cell(:,1))
    if int_cell{i, 5} == 0
        int_cell(i,:) = [];
        i = 0;
    end
    i = i + 1;
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