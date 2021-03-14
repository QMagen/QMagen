function [ GeomConf, ModelConf, Conf ] = SpinModel( Conf )
switch Conf.ModelName
    case 'TLTI'
        % -----------------------------------------------------------------
        % Triangular lattice 
        % Transverse field Ising model
        % Parameter: 
        %           J1     Nearest neighbor term
        %           J2     Next-nearest neighbor term
        %           Delta  Transverse field term
        %           gz     Lande factor of Sz direction
        % 
        % Hamiltonian:
        %   H = J1 \sum_<i,j> Sz_i Sz_j 
        %       + J2 \sum_<<i,j>> Sz_i Sz_j 
        %       - Delta\sum_i Sx_i 
        %       - hz\sum_i Sz_i
        % -----------------------------------------------------------------
        
        % =================================================================
        % DEFAULT SETTINGS
        % =================================================================
        Conf.IntrcMap_Name = 'IntrcMap_TLTI';
        Conf.ModelName_all = 'Triangular lattice-Transverse field Ising model';
        Conf.d = 2;
        ModelConf.Para_List = {'J1', 'J2', 'Delta'};
        ModelConf.Para_Range = cell(length(ModelConf.Para_List), 1);
        ModelConf.Num_gFactor = 1;                           
        ModelConf.Type_gFactor = 'xyz';      
        ModelConf.gFactor = cell(ModelConf.Num_gFactor, 1);       
        ModelConf.gFactor_Vec = cell(ModelConf.Num_gFactor, 1);   
        ModelConf.gFactor_Range = cell(ModelConf.Num_gFactor, 1); 
        ModelConf.gFactor{1} = 'gz';
        ModelConf.gFactor_Vec{1} = [0,0,1];
        
        
        % =================================================================
        % GEOMETRY SETTINGS
        % =================================================================
        GeomConf.Lx = 3;                                   
        GeomConf.Ly = 3;
        GeomConf.BCX = 'OBC';
        GeomConf.BCY = 'PBC';
        Conf.L = GeomConf.Lx * GeomConf.Ly;
        
        % =================================================================
        % PARAMETER SETTINGS
        % =================================================================
        % J1 range
        ModelConf.Para_Range{1} = [5, 20];  
        % J2 range
        ModelConf.Para_Range{2} = [0, 5];  
        % Delta range
        ModelConf.Para_Range{3} = [0, 12];  
        % gz range
        ModelConf.gFactor_Range{1} = [5, 20]; 
        
    case 'TLXXZ'
        % -----------------------------------------------------------------
        % Triangular lattice 
        % XXZ model
        % Parameter: 
        %           J1xy        Nearest neighbor SxSx+SySy term
        %           Delta1      Nearest neighbor SzSz term
        %           J2xy        Next-nearest neighbor SxSx+SySy term
        %           Delta2      Next-nearest neighbor SzSz term
        %           gx          Lande factor of Sx direction
        %           gz          Lande factor of Sz direction
        % 
        % Hamiltonian:
        %   H = \sum_<i,j> J1xy (Sx_i Sx_j + Sy_i Sy_j) + Delta1 Sz_i Sz_j
        %       + \sum_<<i,j>> J1xy (Sx_i Sx_j + Sy_i Sy_j) + Delta1 Sz_i Sz_j
        %       - h\sum_i Sh_i
        % -----------------------------------------------------------------
        
        % =================================================================
        % DEFAULT SETTINGS
        % =================================================================
        Conf.IntrcMap_Name = 'IntrcMap_TLXXZ';
        Conf.ModelName_all = 'Triangular lattice-XXZ model';
        Conf.d = 2;
        ModelConf.Para_List = {'J1xy', 'Delta1', 'J2xy', 'Delta2'};
        ModelConf.Para_Range = cell(length(ModelConf.Para_List), 1);
        ModelConf.Num_gFactor = 2;                           
        ModelConf.Type_gFactor = 'xyz';      
        ModelConf.gFactor = cell(ModelConf.Num_gFactor, 1);       
        ModelConf.gFactor_Vec = cell(ModelConf.Num_gFactor, 1);   
        ModelConf.gFactor_Range = cell(ModelConf.Num_gFactor, 1); 
        ModelConf.gFactor{1} = 'gx';
        ModelConf.gFactor_Vec{1} = [1,0,0];
        ModelConf.gFactor{2} = 'gz';
        ModelConf.gFactor_Vec{2} = [0,0,1];
        
        % =================================================================
        % GEOMETRY SETTINGS
        % =================================================================
        GeomConf.Lx = 3;                                   
        GeomConf.Ly = 3;
        GeomConf.BCX = 'OBC';
        GeomConf.BCY = 'PBC';
        Conf.L = GeomConf.Lx * GeomConf.Ly;
        
        % =================================================================
        % PARAMETER SETTINGS
        % =================================================================
        % J1xy range
        ModelConf.Para_Range{1} = [5, 20];  
        % Delta1 range
        ModelConf.Para_Range{2} = 'J1xy';  
        % J2xy range
        ModelConf.Para_Range{3} = [0, 20];  
        % Delta2 range
        ModelConf.Para_Range{4} = 'J2xy';  
        % gx range
        ModelConf.gFactor_Range{1} = 'gz'; 
        % gz range
        ModelConf.gFactor_Range{2} = [1.5, 3];
    otherwise
        error('Undefined model name!\n')
        
end
end