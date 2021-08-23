function [ Intr ] = IntrcMap( Para )
% Kagome lattice 
% nn only
Lx = Para.Lx;
Ly = Para.Ly;
BCY = Para.BCY;
int_num = 6 * Lx * Ly - 2 * (Lx + Ly) + 1;
if strcmp(BCY, 'PBC')
    int_num = int_num + 2 * Lx - 1;
end
int_cell = cell(int_num * 3, 3);
int_count = 1;
for Lx_i = 1:1:Lx
    base_num = 3 * Ly * (Lx_i - 1);
    
    for i = 1:1:(2 * Ly - 1)
        int_cell{int_count, 1} = base_num + i;
        int_cell{int_count, 2} = base_num + i + 1;
        int_cell{int_count, 3} = 'Sx';
        int_cell{int_count, 4} = 'Sx';
        int_cell{int_count, 5} = 1;
        
        int_cell{int_count+1, 1} = base_num + i;
        int_cell{int_count+1, 2} = base_num + i + 1;
        int_cell{int_count+1, 3} = 'Sy';
        int_cell{int_count+1, 4} = 'Sy';
        int_cell{int_count+1, 5} = 1;
        
        int_cell{int_count+2, 1} = base_num + i;
        int_cell{int_count+2, 2} = base_num + i + 1;
        int_cell{int_count+2, 3} = 'Sz';
        int_cell{int_count+2, 4} = 'Sz';
        int_cell{int_count+2, 5} = 1;
        int_count = int_count + 3;
    end
    
    for i = 1:1:Ly
        int_cell{int_count, 1} = base_num + 2 * i - 1;
        int_cell{int_count, 2} = base_num + 2 * Ly + i;
        int_cell{int_count, 3} = 'Sx';
        int_cell{int_count, 4} = 'Sx';
        int_cell{int_count, 5} = 1;
        
        int_cell{int_count+1, 1} = base_num + 2 * i - 1;
        int_cell{int_count+1, 2} = base_num + 2 * Ly + i;
        int_cell{int_count+1, 3} = 'Sy';
        int_cell{int_count+1, 4} = 'Sy';
        int_cell{int_count+1, 5} = 1;
        
        int_cell{int_count+2, 1} = base_num + 2 * i - 1;
        int_cell{int_count+2, 2} = base_num + 2 * Ly + i;
        int_cell{int_count+2, 3} = 'Sz';
        int_cell{int_count+2, 4} = 'Sz';
        int_cell{int_count+2, 5} = 1;
        
        int_count = int_count + 3;
        
        int_cell{int_count, 1} = base_num + 2 * i;
        int_cell{int_count, 2} = base_num + 2 * Ly + i;
        int_cell{int_count, 3} = 'Sx';
        int_cell{int_count, 4} = 'Sx';
        int_cell{int_count, 5} = 1;
        
        int_cell{int_count+1, 1} = base_num + 2 * i;
        int_cell{int_count+1, 2} = base_num + 2 * Ly + i;
        int_cell{int_count+1, 3} = 'Sy';
        int_cell{int_count+1, 4} = 'Sy';
        int_cell{int_count+1, 5} = 1;
        
        int_cell{int_count+2, 1} = base_num + 2 * i;
        int_cell{int_count+2, 2} = base_num + 2 * Ly + i;
        int_cell{int_count+2, 3} = 'Sz';
        int_cell{int_count+2, 4} = 'Sz';
        int_cell{int_count+2, 5} = 1;
        
        int_count = int_count + 3;
    end
    
    if Lx_i < Lx
        for i = 1:1:Ly
            int_cell{int_count, 1} = base_num + 2 * Ly + i;
            int_cell{int_count, 2} = base_num + 3 * Ly + 2 * i;
            int_cell{int_count, 3} = 'Sx';
            int_cell{int_count, 4} = 'Sx';
            int_cell{int_count, 5} = 1;
            
            int_cell{int_count+1, 1} = base_num + 2 * Ly + i;
            int_cell{int_count+1, 2} = base_num + 3 * Ly + 2 * i;
            int_cell{int_count+1, 3} = 'Sy';
            int_cell{int_count+1, 4} = 'Sy';
            int_cell{int_count+1, 5} = 1;
            
            int_cell{int_count+2, 1} = base_num + 2 * Ly + i;
            int_cell{int_count+2, 2} = base_num + 3 * Ly + 2 * i;
            int_cell{int_count+2, 3} = 'Sz';
            int_cell{int_count+2, 4} = 'Sz';
            int_cell{int_count+2, 5} = 1;
            
            int_count = int_count + 3;
            
            if i < Ly
                int_cell{int_count, 1} = base_num + 2 * Ly + i;
                int_cell{int_count, 2} = base_num + 3 * Ly + 2 * i + 1;
                int_cell{int_count, 3} = 'Sx';
                int_cell{int_count, 4} = 'Sx';
                int_cell{int_count, 5} = 1;
                
                int_cell{int_count+1, 1} = base_num + 2 * Ly + i;
                int_cell{int_count+1, 2} = base_num + 3 * Ly + 2 * i + 1;
                int_cell{int_count+1, 3} = 'Sy';
                int_cell{int_count+1, 4} = 'Sy';
                int_cell{int_count+1, 5} = 1;
                
                int_cell{int_count+2, 1} = base_num + 2 * Ly + i;
                int_cell{int_count+2, 2} = base_num + 3 * Ly + 2 * i + 1;
                int_cell{int_count+2, 3} = 'Sz';
                int_cell{int_count+2, 4} = 'Sz';
                int_cell{int_count+2, 5} = 1;
                
                int_count = int_count + 3;
            end
        end
    end
    
    if strcmp(BCY, 'PBC')
        int_cell{int_count, 1} = base_num + 1;
        int_cell{int_count, 2} = base_num + 2 * Ly;
        int_cell{int_count, 3} = 'Sx';
        int_cell{int_count, 4} = 'Sx';
        int_cell{int_count, 5} = 1;
        
        int_cell{int_count+1, 1} = base_num + 1;
        int_cell{int_count+1, 2} = base_num + 2 * Ly;
        int_cell{int_count+1, 3} = 'Sy';
        int_cell{int_count+1, 4} = 'Sy';
        int_cell{int_count+1, 5} = 1;
        
        int_cell{int_count+2, 1} = base_num + 1;
        int_cell{int_count+2, 2} = base_num + 2 * Ly;
        int_cell{int_count+2, 3} = 'Sz';
        int_cell{int_count+2, 4} = 'Sz';
        int_cell{int_count+2, 5} = 1;
        
        int_count = int_count + 3;
        if Lx_i < Lx
            int_cell{int_count, 1} = base_num + 3 * Ly;
            int_cell{int_count, 2} = base_num + 3 * Ly + 1;
            int_cell{int_count, 3} = 'Sx';
            int_cell{int_count, 4} = 'Sx';
            int_cell{int_count, 5} = 1;
            
            int_cell{int_count+1, 1} = base_num + 3 * Ly;
            int_cell{int_count+1, 2} = base_num + 3 * Ly + 1;
            int_cell{int_count+1, 3} = 'Sy';
            int_cell{int_count+1, 4} = 'Sy';
            int_cell{int_count+1, 5} = 1;
            
            int_cell{int_count+2, 1} = base_num + 3 * Ly;
            int_cell{int_count+2, 2} = base_num + 3 * Ly + 1;
            int_cell{int_count+2, 3} = 'Sz';
            int_cell{int_count+2, 4} = 'Sz';
            int_cell{int_count+2, 5} = 1;
            
            int_count = int_count + 3;
        end
    end
end
int_count - 1;
Intr = struct('JmpOut', int_cell(:,1), 'JmpIn', int_cell(:,2), ...
              'JmpOut_type', int_cell(:,3), 'JmpIn_type', int_cell(:,4), 'CS', int_cell(:,5));
end

