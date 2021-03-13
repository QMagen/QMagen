function [ GeomConf, ModelConf ] = SpinModel( Conf )
switch Conf.ModelName
    case 'TLTI'
        % =================================================================
        % DEFAULT SETTINGS
        % =================================================================
        Conf.IntrcMap_Name = 'IntrcMap_TLTI';
        ModelConf.Para_List = {'J1', 'J2', 'Delta'};
        ModelConf.Para_Range = cell(length(ModelConf.Para_List), 1);
        ModelConf.Num_gFactor = 1;                           
        ModelConf.Type_gFactor = 'xyz';      
        ModelConf.gFactor = cell(ModelConf.Num_gFactor, 1);       
        ModelConf.gFactor_Vec = cell(ModelConf.Num_gFactor, 1);   
        ModelConf.gFacotr_Range = cell(ModelConf.Num_gFactor, 1); 
        ModelConf.gFactor{1} = 'gz';
        ModelConf.gFactor_Vec{1} = [0,0,1];
        
        
        % =================================================================
        % GEOMETRY SETTINGS
        % =================================================================
        GeomConf.Lx = 3;                                   
        GeomConf.Ly = 3;
        GeomConf.BCX = 'OBC';
        GeomConf.BCY = 'PBC';
        
        
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
        ModelConf.gFacotr_Range{1} = [5, 20]; 
        
    otherwise
        fprintf('1!\n')
        keyboard;
        
end
end