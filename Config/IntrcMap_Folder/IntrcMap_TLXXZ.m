function [ Intr ] = IntrcMap_TLXXZ( Para )
% Triangular lattice 
% XXZ model
% Parameter: 
%           J1xy        Nearest neighbor SxSx+SySy term
%           J1z         Nearest neighbor SzSz term
%           J2xy        Next-nearest neighbor SxSx+SySy term
%           J2z         Next-nearest neighbor SzSz term
% 
% Hamiltonian:
%   H = \sum_<i,j> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%       + \sum_<<i,j>> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%       - h\sum_i Sh_i
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
int_num = int_num * 3;
int_cell = cell(int_num, 5);
count = 1;

% OBC part

for x = 1:1:Lx
    bnum = Ly * (x - 1);
    
    % nn along y dir
    for y = 1:1:(Ly-1)
        
        int_cell{count, 1} = bnum + y;
        int_cell{count, 2} = bnum + y + 1;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J1xy;
        
        int_cell{count+1, 1} = bnum + y;
        int_cell{count+1, 2} = bnum + y + 1;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J1xy;
        
        int_cell{count+2, 1} = bnum + y;
        int_cell{count+2, 2} = bnum + y + 1;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J1z;
        
        count = count + 3;
    end
    
    if x ~= Lx
        % nn along x dir
        for y = 1:1:Ly
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y;
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = Para.Model.J1xy;
        
            int_cell{count+1, 1} = bnum + y;
            int_cell{count+1, 2} = bnum + Ly + y;
            int_cell{count+1, 3} = 'Sy';
            int_cell{count+1, 4} = 'Sy';
            int_cell{count+1, 5} = Para.Model.J1xy;
            
            int_cell{count+2, 1} = bnum + y;
            int_cell{count+2, 2} = bnum + Ly + y;
            int_cell{count+2, 3} = 'Sz';
            int_cell{count+2, 4} = 'Sz';
            int_cell{count+2, 5} = Para.Model.J1z;
            
            count = count + 3;
        end
        
        % nn along x-y dir
        for y = 1:1:(Ly-1)
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y + 1;
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = Para.Model.J1xy;
            
            int_cell{count+1, 1} = bnum + y;
            int_cell{count+1, 2} = bnum + Ly + y + 1;
            int_cell{count+1, 3} = 'Sy';
            int_cell{count+1, 4} = 'Sy';
            int_cell{count+1, 5} = Para.Model.J1xy;
            
            int_cell{count+2, 1} = bnum + y;
            int_cell{count+2, 2} = bnum + Ly + y + 1;
            int_cell{count+2, 3} = 'Sz';
            int_cell{count+2, 4} = 'Sz';
            int_cell{count+2, 5} = Para.Model.J1z;
            
            count = count + 3;
        end
        
        % nnn along x+y dir
        for y = 2:1:Ly
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y - 1;
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = Para.Model.J2xy;
            
            int_cell{count+1, 1} = bnum + y;
            int_cell{count+1, 2} = bnum + Ly + y - 1;
            int_cell{count+1, 3} = 'Sy';
            int_cell{count+1, 4} = 'Sy';
            int_cell{count+1, 5} = Para.Model.J2xy;
            
            int_cell{count+2, 1} = bnum + y;
            int_cell{count+2, 2} = bnum + Ly + y - 1;
            int_cell{count+2, 3} = 'Sz';
            int_cell{count+2, 4} = 'Sz';
            int_cell{count+2, 5} = Para.Model.J2z;
        
            count = count + 3;
        end
        
        % nnn along x-2y dir
        for y = 1:1:(Ly-2)
        
            int_cell{count, 1} = bnum + y;
            int_cell{count, 2} = bnum + Ly + y + 2;
            int_cell{count, 3} = 'Sx';
            int_cell{count, 4} = 'Sx';
            int_cell{count, 5} = Para.Model.J2xy;
            
            int_cell{count+1, 1} = bnum + y;
            int_cell{count+1, 2} = bnum + Ly + y + 2;
            int_cell{count+1, 3} = 'Sy';
            int_cell{count+1, 4} = 'Sy';
            int_cell{count+1, 5} = Para.Model.J2xy;
            
            int_cell{count+2, 1} = bnum + y;
            int_cell{count+2, 2} = bnum + Ly + y + 2;
            int_cell{count+2, 3} = 'Sz';
            int_cell{count+2, 4} = 'Sz';
            int_cell{count+2, 5} = Para.Model.J2z;
            
            count = count + 3;
        end
        
        if x ~= Lx - 1
            % nnn along 
            for y = 1:1:(Ly-1)
        
                int_cell{count, 1} = bnum + y;
                int_cell{count, 2} = bnum + 2 * Ly + y + 1;
                int_cell{count, 3} = 'Sx';
                int_cell{count, 4} = 'Sx';
                int_cell{count, 5} = Para.Model.J2xy;
                
                int_cell{count+1, 1} = bnum + y;
                int_cell{count+1, 2} = bnum + 2 * Ly + y + 1;
                int_cell{count+1, 3} = 'Sy';
                int_cell{count+1, 4} = 'Sy';
                int_cell{count+1, 5} = Para.Model.J2xy;
                
                int_cell{count+2, 1} = bnum + y;
                int_cell{count+2, 2} = bnum + 2 * Ly + y + 1;
                int_cell{count+2, 3} = 'Sz';
                int_cell{count+2, 4} = 'Sz';
                int_cell{count+2, 5} = Para.Model.J2z;
                
                count = count + 3;
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
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J1xy;
        
        int_cell{count+1, 1} = y;
        int_cell{count+1, 2} = bnum + y;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J1xy;
        
        int_cell{count+2, 1} = y;
        int_cell{count+2, 2} = bnum + y;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J1z;
        
        count = count + 3;
    end
    
    for y = 2:1:Ly
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y - 1;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J1xy;
        
        int_cell{count+1, 1} = y;
        int_cell{count+1, 2} = bnum + y - 1;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J1xy;
        
        int_cell{count+2, 1} = y;
        int_cell{count+2, 2} = bnum + y - 1;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J1z;
        
        count = count + 3;
    end
    
    for y = 1:1:(Ly-1)
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y + 1;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J2xy;
        
        int_cell{count+1, 1} = y;
        int_cell{count+1, 2} = bnum + y + 1;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J2xy;
        
        int_cell{count+2, 1} = y;
        int_cell{count+2, 2} = bnum + y + 1;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J2z;
        
        count = count + 3;
    end
    
    for y = 3:1:Ly
        bnum = Ly * (Lx - 1);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y - 2;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J2xy;
        
        int_cell{count+1, 1} = y;
        int_cell{count+1, 2} = bnum + y - 2;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J2xy;
        
        int_cell{count+2, 1} = y;
        int_cell{count+2, 2} = bnum + y - 2;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J2z;
        
        count = count + 3;
    end
    
    for y = 2:1:Ly
        bnum = Ly * (Lx - 2);
        
        int_cell{count, 1} = y;
        int_cell{count, 2} = bnum + y - 1;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J2xy;
        
        int_cell{count+1, 1} = y;
        int_cell{count+1, 2} = bnum + y - 1;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J2xy;
        
        int_cell{count+2, 1} = y;
        int_cell{count+2, 2} = bnum + y - 1;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J2z;
        
        count = count + 3;
    end
    
end

if strcmp(BCY, 'PBC')
    for x = 1:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = x*Ly;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J1xy;
        
        int_cell{count+1, 1} = (x-1)*Ly+1;
        int_cell{count+1, 2} = x*Ly;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J1xy;
        
        int_cell{count+2, 1} = (x-1)*Ly+1;
        int_cell{count+2, 2} = x*Ly;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J1z;
        
        count = count + 3;
    end
    
    for x = 2:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = (x-1)*Ly;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J1xy;
        
        int_cell{count+1, 1} = (x-1)*Ly+1;
        int_cell{count+1, 2} = (x-1)*Ly;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J1xy;
        
        int_cell{count+2, 1} = (x-1)*Ly+1;
        int_cell{count+2, 2} = (x-1)*Ly;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J1z;
        
        count = count + 3;
    end
    
    for x = 1:1:(Lx-1)       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = (x+1)*Ly;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J2xy;
        
        int_cell{count+1, 1} = (x-1)*Ly+1;
        int_cell{count+1, 2} = (x+1)*Ly;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J2xy;
        
        int_cell{count+2, 1} = (x-1)*Ly+1;
        int_cell{count+2, 2} = (x+1)*Ly;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J2z;
        
        count = count + 3;
    end
    
    for x = 2:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+2;
        int_cell{count, 2} = (x-1)*Ly;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J2xy;
        
        int_cell{count+1, 1} = (x-1)*Ly+2;
        int_cell{count+1, 2} = (x-1)*Ly;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J2xy;
        
        int_cell{count+2, 1} = (x-1)*Ly+2;
        int_cell{count+2, 2} = (x-1)*Ly;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J2z;
        
        count = count + 3;
    end
    
    for x = 3:1:Lx       
        
        int_cell{count, 1} = (x-1)*Ly+1;
        int_cell{count, 2} = (x-2)*Ly;
        int_cell{count, 3} = 'Sx';
        int_cell{count, 4} = 'Sx';
        int_cell{count, 5} = Para.Model.J2xy;
        
        int_cell{count+1, 1} = (x-1)*Ly+1;
        int_cell{count+1, 2} = (x-2)*Ly;
        int_cell{count+1, 3} = 'Sy';
        int_cell{count+1, 4} = 'Sy';
        int_cell{count+1, 5} = Para.Model.J2xy;
        
        int_cell{count+2, 1} = (x-1)*Ly+1;
        int_cell{count+2, 2} = (x-2)*Ly;
        int_cell{count+2, 3} = 'Sz';
        int_cell{count+2, 4} = 'Sz';
        int_cell{count+2, 5} = Para.Model.J2z;
        
        count = count + 3;
    end
    
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