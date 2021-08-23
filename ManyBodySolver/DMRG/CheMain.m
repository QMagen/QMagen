function [Co, mu, ts1, ts0] = CheMain(Para, q, T, Ope, Hrs)
Para.q = q;
% Get operator O1 and O2
[O1, O2] = GetSOpe( Ope, Para );

% Chebyshev expansion
mu = zeros(Para.CheMaxStep, 1);

% Init Chebyshev exoansion
[ts0.A, Ns, ~] = VariProdMPS(Para, T.A, O2.A);
ts0.lgnorm = log(Ns);
mu(1) = Getmu( Para, T, ts0, O1 );

[ts1.A, Ns, ~] = VariProdMPS(Para, ts0.A, Hrs.A);
ts1.lgnorm = log(Ns) + ts0.lgnorm + Hrs.lgnorm;
mu(2) = Getmu( Para, T, ts1, O1 );

for i = 3:1:Para.CheMaxStep
    %fprintf('%d', i)
    %tic
    [ts] = UpdateChe(Para, Hrs, ts1, ts0);
    mu(i) = Getmu( Para, T, ts, O1 );
    %toc
    ts0 = ts1;
    ts1 = ts;
end

Co = CheAprox(Para.omegap, mu);
end

