function [ Intr ] = IntrcMap_TLI( Para )
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
Lx = Para.Geo.Lx;
Ly = Para.Geo.Ly;
L = Lx * Ly;
int_num = Lx*(Ly-1)+Ly*(Lx-1)+(Lx-1)*(Ly-1)+(Lx-1)*(Ly-1)+(Ly-2)*(Lx-1)+(Lx-2)*(Ly-1);
BCX = Para.Geo.BCX;
BCY = Para.Geo.BCY;

if strcmp(BCX, 'PBC')
    int_num = int_num + Ly + (Ly - 1) + (Ly - 1) + (Ly - 1) + (Ly - 2);
end

if strcmp(BCY, 'PBC')
    int_num = int_num + Lx + (Lx - 1) + (Lx - 1) + (Lx - 1) + (Lx - 2);
end
int_num = int_num + Lx * Ly;
int_cell = cell(int_num, 5);
count = 1;

% OBC part

for x = 1:1:Lx
    bnum = Ly * (x - 1);
    
    % nn along y dir
    for y = 1:1:(Ly-1)
        
        int_cell{count, 1} = bnum + y;
        int_cell{count, 2} = bnum + y + 1;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J1;
        
        count = count + 1;
    end
    
    if x ~= Lx
        % nn along x dir
        for y = 1:1:Ly
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y;
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = Para.Model.J1;
        
            count = count + 1;
        end
        
        % nn along x-y dir
        for y = 1:1:(Ly-1)
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y + 1;
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = Para.Model.J1;
        
            count = count + 1;
        end
        
        % nnn along x+y dir
        for y = 2:1:Ly
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y - 1;
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = Para.Model.J2;
        
            count = count + 1;
        end
        
        % nnn along x-2y dir
        for y = 1:1:(Ly-2)
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y + 2;
            int_cell{count, 3} = 'Sz';
            int_cell{count, 4} = 'Sz';
            int_cell{count, 5} = Para.Model.J2;
        
            count = count + 1;
        end
        
        if x ~= Lx - 1
            % nnn along 
            for y = 1:1:(Ly-1)
        
                int_cell{count, 1} = bnum + y;
                int_cell{count, 2} = bnum + 2 * Ly + y + 1;
                int_cell{count, 3} = 'Sz';
                int_cell{count, 4} = 'Sz';
                int_cell{count, 5} = Para.Model.J2;
        
                count = count + 1;
            end
        end
    end
end

% PBC part

if strcmp(BCX, 'PBC')
    
    for y = 1:1:Ly
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J1;
        
        count = count + 1;
    end
    
    for y = 2:1:Ly
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y - 1;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J1;
        
        count = count + 1;
    end
    
    for y = 1:1:(Ly-1)
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y + 1;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J2;
        
        count = count + 1;
    end
    
    for y = 3:1:Ly
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y - 2;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J2;
        
        count = count + 1;
    end
    
    for y = 2:1:Ly
        bnum = Ly * (Lx - 2);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y - 1;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J2;
        
        count = count + 1;
    end
    
end

if strcmp(BCY, 'PBC')
    for x = 1:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = x*Ly;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J1;
        
        count = count + 1;
    end
    
    for x = 2:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = (x-1)*Ly;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J1;
        
        count = count + 1;
    end
    
    for x = 1:1:(Lx-1)       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = (x+1)*Ly;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J2;
        
        count = count + 1;
    end
    
    for x = 2:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+2;
        int_cell{count, 2} = (x-1)*Ly;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J2;
        
        count = count + 1;
    end
    
    for x = 3:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = (x-2)*Ly;
        int_cell{count, 3} = 'Sz';
        int_cell{count, 4} = 'Sz';
        int_cell{count, 5} = Para.Model.J2;
        
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