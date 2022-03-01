function [ Lattice, ModelConf, Config ] = GetSpinModel( Config )

switch Config.ModelName
    case 'XXZtest'
        [ Lattice, ModelConf ] = SpinModel_XXZtest( );
    case 'HAFC'
        [ Lattice, ModelConf ] = SpinModel_HAFC( );
    case 'TLXXZ'
        [ Lattice, ModelConf ] = SpinModel_TLXXZ( );
    case 'TLI'
        [ Lattice, ModelConf ] = SpinModel_TLI( );
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