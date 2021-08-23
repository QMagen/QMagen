function [ En ] = Observe( MPS, Ham, Para )

[ C, ns ] = VariProdMPS( Para, MPS.A, Ham.A );
res = real(InnerProdMPS(C, MPS.A));
% if ~isempty(varargin)
%     lognorm = lognorm + 2 * varargin{1};
% end
En = ns * res * exp(Ham.lgnorm);

end

