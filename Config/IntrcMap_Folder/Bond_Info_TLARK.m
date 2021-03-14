function [ Bond_cell ] = Bond_Info_TLARK( Para )
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
Bond_num = Lx*(Ly-1)+Ly*(Lx-1)+(Lx-1)*(Ly-1)+(Lx-1)*(Ly-1)+(Ly-2)*(Lx-1)+(Lx-2)*(Ly-1);
BCX = Para.Geo.BCX;
BCY = Para.Geo.BCY;

if strcmp(BCX, 'PBC')
    Bond_num = Bond_num + Ly + (Ly - 1) + (Ly - 1) + (Ly - 1) + (Ly - 2);
end

if strcmp(BCY, 'PBC')
    Bond_num = Bond_num + Lx + (Lx - 1) + (Lx - 1) + (Lx - 1) + (Lx - 2);
end
Bond_cell = cell(Bond_num, 3);
count = 1;

% OBC part

for x = 1:1:Lx
    bnum = Ly * (x - 1);
    
    % nn along y dir
    for y = 1:1:(Ly-1)
        
        Bond_cell{count, 1} = bnum + y;
        Bond_cell{count, 2} = bnum + y + 1;
        Bond_cell{count, 3} = 'nn-3';
        
        count = count + 1;
    end
    
    if x ~= Lx
        % nn along x dir
        for y = 1:1:Ly
        
            Bond_cell{count, 1} = bnum + y;
            Bond_cell{count, 2} = bnum + Ly + y;
            Bond_cell{count, 3} = 'nn-1';
            
            count = count + 1;
        end
        
        % nn along x-y dir
        for y = 1:1:(Ly-1)
        
            Bond_cell{count, 1} = bnum + y;
            Bond_cell{count, 2} = bnum + Ly + y + 1;
            Bond_cell{count, 3} = 'nn-2';

            count = count + 1;
        end
        
        % nnn along x+y dir
        for y = 2:1:Ly
        
            Bond_cell{count, 1} = bnum + y;
            Bond_cell{count, 2} = bnum + Ly + y - 1;
            Bond_cell{count, 3} = 'nnn';
        
            count = count + 1;
        end
        
        % nnn along x-2y dir
        for y = 1:1:(Ly-2)
        
            Bond_cell{count, 1} = bnum + y;
            Bond_cell{count, 2} = bnum + Ly + y + 2;
            Bond_cell{count, 3} = 'nnn';
            
            
            count = count + 1;
        end
        
        if x ~= Lx - 1
            % nnn along 
            for y = 1:1:(Ly-1)
        
                Bond_cell{count, 1} = bnum + y;
                Bond_cell{count, 2} = bnum + 2 * Ly + y + 1;
                Bond_cell{count, 3} = 'nnn';
                
                count = count + 1;
            end
        end
    end
end

% PBC part

if strcmp(BCX, 'PBC')
    
    for y = 1:1:Ly
        bnum = Ly * (Lx - 1);
        
        Bond_cell{count, 1} = y;
        Bond_cell{count, 2} = bnum + y;
        Bond_cell{count, 3} = 'nn-1';
        
        count = count + 1;
    end
    
    for y = 2:1:Ly
        bnum = Ly * (Lx - 1);
        
        Bond_cell{count, 1} = y;
        Bond_cell{count, 2} = bnum + y - 1;
        Bond_cell{count, 3} = 'nn-2';
        
        count = count + 1;
    end
    
    for y = 1:1:(Ly-1)
        bnum = Ly * (Lx - 1);
        
        Bond_cell{count, 1} = y;
        Bond_cell{count, 2} = bnum + y + 1;
        Bond_cell{count, 3} = 'nnn';
        
        count = count + 1;
    end
    
    for y = 3:1:Ly
        bnum = Ly * (Lx - 1);
        
        Bond_cell{count, 1} = y;
        Bond_cell{count, 2} = bnum + y - 2;
        Bond_cell{count, 3} = 'nnn';
        
        count = count + 1;
    end
    
    for y = 2:1:Ly
        bnum = Ly * (Lx - 2);
        
        Bond_cell{count, 1} = y;
        Bond_cell{count, 2} = bnum + y - 1;
        Bond_cell{count, 3} = 'nnn';
        
        count = count + 1;
    end
    
end

if strcmp(BCY, 'PBC')
    for x = 1:1:Lx       
        
        Bond_cell{count, 1} = (x-1)*Ly+1;
        Bond_cell{count, 2} = x*Ly;
        Bond_cell{count, 3} = 'nn-3';
        
        count = count + 1;
    end
    
    for x = 2:1:Lx       
        
        Bond_cell{count, 1} = (x-1)*Ly+1;
        Bond_cell{count, 2} = (x-1)*Ly;
        Bond_cell{count, 3} = 'nn-2';
        
        count = count + 1;
    end
    
    for x = 1:1:(Lx-1)       
        
        Bond_cell{count, 1} = (x-1)*Ly+1;
        Bond_cell{count, 2} = (x+1)*Ly;
        Bond_cell{count, 3} = 'nnn';
        
        count = count + 1;
    end
    
    for x = 2:1:Lx       
        
        Bond_cell{count, 1} = (x-1)*Ly+2;
        Bond_cell{count, 2} = (x-1)*Ly;
        Bond_cell{count, 3} = 'nnn';
        
        count = count + 1;
    end
    
    for x = 3:1:Lx       
        
        Bond_cell{count, 1} = (x-1)*Ly+1;
        Bond_cell{count, 2} = (x-2)*Ly;
        Bond_cell{count, 3} = 'nnn';
        
        count = count + 1;
    end
    
end

end