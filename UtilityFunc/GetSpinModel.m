function [ Lattice, ModelConf, Config ] = GetSpinModel( Config )

switch Config.ModelName
    case 'TLTI'
        [ Lattice, ModelConf ] = SpinModel_TLTI( );
        
    case 'TLXXZ'
        [ Lattice, ModelConf ] = SpinModel_TLXXZ( );
        
    case 'TLARX'
        [ Lattice, ModelConf ] = SpinModel_TLARX( );
        
    otherwise
        error('Undefined model name!\n')
        
end
end