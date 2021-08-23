function [ C, Ns2 ] = VariSumMPO( Para, MPOA, MPOB, varargin )

switch Para.Ver
    case 'Memory'
        [ C, Ns2 ] = VariSumMPOMem( Para, MPOA, MPOB, varargin{1} );
    otherwise 
        error('!')
end
end

