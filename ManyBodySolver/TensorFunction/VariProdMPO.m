function [ C, Ns2 ] = VariProdMPO( Para, MPOA, MPOB )

switch Para.Ver
    case 'Memory'
        [ C, Ns2 ] = VariProdMPOMem( Para, MPOA, MPOB );
    otherwise 
        error('!')
end
end

