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
        error('Undefined model name!\n')
        
end
end