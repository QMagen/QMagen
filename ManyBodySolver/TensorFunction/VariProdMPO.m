function [ C, Ns2, TE, EE ] = VariProdMPO( Para, MPOA, MPOB )

switch Para.Ver
    case 'Memory'
        [ C, Ns2, TE, EE ] = VariProdMPOMem( Para, MPOA, MPOB );
    otherwise 
        error('!')
end
end

