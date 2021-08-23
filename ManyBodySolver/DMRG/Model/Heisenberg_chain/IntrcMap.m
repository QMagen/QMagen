function [ Intr ] = IntrcMap( Para )

% Heisenberg Chain

L = Para.L;
int_num = L-1;
BCX = Para.BCX;
if strcmp(BCX, 'PBC')
    int_num = int_num + 1;
end
int_num = 3 * int_num;
int_cell = cell(int_num, 5);
count = 1;

% nearst neighbor interaction
for i = 1:1:(L - 1)
    int_cell{count, 1} = i;
    int_cell{count, 2} = i+1;
    int_cell{count, 3} = 'Sx';
    int_cell{count, 4} = 'Sx';
    
    int_cell{count+1, 1} = i;
    int_cell{count+1, 2} = i+1;
    int_cell{count+1, 3} = 'Sy';
    int_cell{count+1, 4} = 'Sy';
    
    int_cell{count+2, 1} = i;
    int_cell{count+2, 2} = i+1;
    int_cell{count+2, 3} = 'Sz';
    int_cell{count+2, 4} = 'Sz';
    
    if mod(i,2) == 1
        int_cell{count, 5} = Para.Model.J;
        int_cell{count+1, 5} = Para.Model.J;
        int_cell{count+2, 5} = Para.Model.J;
    else
        int_cell{count, 5} = Para.Model.J;
        int_cell{count+1, 5} = Para.Model.J;
        int_cell{count+2, 5} = Para.Model.J;
    end
    count = count + 3;
end

Intr = struct('JmpOut', int_cell(:,1), 'JmpIn', int_cell(:,2), ...
              'JmpOut_type', int_cell(:,3), 'JmpIn_type', int_cell(:,4), 'CS', int_cell(:,5));
          
end

