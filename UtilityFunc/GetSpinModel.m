function [ GeomConf, ModelConf, Conf ] = GetSpinModel( ip )
if ischar(ip)
    load(['ModelConfig/', ip, '.mat']);
else
    Conf = ip;
    switch Conf.ModelName
        case 'TLTI'
            [ GeomConf, ModelConf, Conf ] = SpinModel_TLTI( Conf );
            
        case 'TLXXZ'
            [ GeomConf, ModelConf, Conf ] = SpinModel_TLXXZ( Conf );
            
        case 'TLARX'
            [ GeomConf, ModelConf, Conf ] = SpinModel_TLARX( Conf );
            
        otherwise
            error('Undefined model name!\n')
        
    end
end
end