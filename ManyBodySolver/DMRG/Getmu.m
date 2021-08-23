function [ mu ] = Getmu( Para, GS, tn, O )

[ C, ns ] = VariProdMPS( Para, tn.A, O.A );
res = real(InnerProd(C, GS.A));
% if ~isempty(varargin)
%     lognorm = lognorm + 2 * varargin{1};
% end
mu = ns * res * exp(tn.lgnorm) * exp(GS.lgnorm);

end

