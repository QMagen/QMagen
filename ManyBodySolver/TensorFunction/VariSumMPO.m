function [ C, Ns2, TE, EE ] = VariSumMPO( Para, MPOA, MPOB, varargin )

switch Para.Ver
    case 'Memory'
        [ C, Ns2, TE, EE ] = VariSumMPOMem( Para, MPOA, MPOB, varargin{1} );
    otherwise 
        error('!')
end
end

