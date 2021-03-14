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
        ModelConf.Para_List = {'J1xy', 'J1z', 'J2xy', 'J2z'};
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
        % J1z range
        ModelConf.Para_Range{2} = 'J1xy';  
        % J2xy range
        ModelConf.Para_Range{3} = [0, 20];  
        % J2z range
        ModelConf.Para_Range{4} = 'J2xy';  
        % gx range
        ModelConf.gFactor_Range{1} = 'gz'; 
        % gz range
        ModelConf.gFactor_Range{2} = [1.5, 3];
           
    case 'TLARK'
        % -----------------------------------------------------------------
        % Triangular lattice 
        % ARK model
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
        % -----------------------------------------------------------------
        
        % =================================================================
        % DEFAULT SETTINGS
        % =================================================================
        Conf.IntrcMap_Name = 'IntrcMap_TLARK';
        Conf.ModelName_all = 'Triangular lattice-ARK model';
        Conf.d = 2;
        ModelConf.Para_List = {'J1xy', 'J1z', 'Jpm', 'Jpmz', 'J2xy', 'J2z', 'Delta'};
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
        % J1z range
        ModelConf.Para_Range{2} = 'J1xy';  
        % Jpm range
        ModelConf.Para_Range{3} = 1;  
        % Jpmz range
        ModelConf.Para_Range{4} = 1;  
        % J2xy range
        ModelConf.Para_Range{5} = [0, 20];  
        % J2z range
        ModelConf.Para_Range{6} = 'J2xy'; 
        % Delta range
        ModelConf.Para_Range{7} = 1;  
        % gx range
        ModelConf.gFactor_Range{1} = 'gz'; 
        % gz range
        ModelConf.gFactor_Range{2} = [1.5, 3];
        
    otherwise
        error('Undefined model name!\n')
        
end
end