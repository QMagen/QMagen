function [ Lattice, ModelConf, Config ] = GetSpinModel( Config )

switch Config.ModelName
    
    case 'XYZC'
        [ Lattice, ModelConf ] = SpinModel_XYZC( );
        
    case 'TLI'
        [ Lattice, ModelConf ] = SpinModel_TLI( );
        
    case 'TLXXZ'
        [ Lattice, ModelConf ] = SpinModel_TLXXZ( );
        
    case 'TLARX'
        [ Lattice, ModelConf ] = SpinModel_TLARX( );
    
    case 'HAFC'
        [ Lattice, ModelConf ] = SpinModel_HAFC( );
        
    otherwise
        warning('Undefined model name!\n')
        pause
end

for i = 1:1:length(ModelConf.Para_Name)
    if strcmp(ModelConf.Para_Name{1}(1), 'g')
        warning('ModelConf.Para_Name cannot begin with the letter g!')
        pause
    end
end

for i = 1:1:ModelConf.gFactor_Num
    if ~strcmp(ModelConf.gFactor_Name{1}(1), 'g')
        warning('ModelConf.gFactor_Name must begin with the letter g!')
        pause
    end
end

end