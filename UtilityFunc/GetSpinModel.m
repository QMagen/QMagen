function [ Lattice, ModelConf, Config ] = GetSpinModel( Config )

switch Config.ModelName
    case 'TLTI'
        [ Lattice, ModelConf, Config ] = SpinModel_TLTI( Config );
        
    case 'TLXXZ'
        [ Lattice, ModelConf, Config ] = SpinModel_TLXXZ( Config );
        
    case 'TLARX'
        [ Lattice, ModelConf, Config ] = SpinModel_TLARX( Config );
        
    otherwise
        error('Undefined model name!\n')
        
end
end