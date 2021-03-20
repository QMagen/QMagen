function [ Lattice, ModelConf, Config ] = GetSpinModel( Config )

switch Config.ModelName
    case 'TLI'
        [ Lattice, ModelConf ] = SpinModel_TLI( );
        
    case 'TLXXZ'
        [ Lattice, ModelConf ] = SpinModel_TLXXZ( );
        
    case 'TLARX'
        [ Lattice, ModelConf ] = SpinModel_TLARX( );
    
    case 'AFHC'
        [ Lattice, ModelConf ] = SpinModel_AFHC( );
    otherwise
        error('Undefined model name!\n')
        
end
end