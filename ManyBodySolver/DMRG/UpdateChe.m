function [t] = UpdateChe(Para, Hrs, t1, t0)
[tp.A, Ns, ~] = VariProdMPS(Para, t1.A, Hrs.A);
tp.lgnorm = log(Ns) + t1.lgnorm + Hrs.lgnorm;
[t.A, Ns, ~] = VariSumMPS( Para, tp.A, t0.A, 2 * exp(tp.lgnorm), -exp(t0.lgnorm));
t.lgnorm = log(Ns);
end

