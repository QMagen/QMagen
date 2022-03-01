function [ CCHA, betaCHA ] = ThDQ_func( Rslt, Para )
tau = Para.tau;
betaCHA = tau.*2.^(0:1:(Para.It+2)).*2^0.1;
for int = 0.3:0.2:0.9
    betaCHA = [betaCHA, tau.*2.^(0:1:(Para.It+2)).*2^int];
end

beta = Rslt.beta;
En = Rslt.En;
betaCHA = sort(betaCHA);

for i = 1:1:length(Rslt.beta)
    if betaCHA(1) < min(Rslt.beta)
        betaCHA(1) = [];
    end
    if betaCHA(end) > max(Rslt.beta)
        betaCHA(end) = [];
    end
end

EnCHA = spline(beta, En, betaCHA);
lnbeta = log(betaCHA);
CCHA = zeros(1, length(betaCHA));
for bt = 2:1:numel(betaCHA)-1
    CCHA(bt) = -betaCHA(bt)*(EnCHA(bt-1) - EnCHA(bt+1))/(lnbeta(bt-1)-lnbeta(bt+1));
end
betaCHA(1) = [];
betaCHA(end) = [];
CCHA(1) = [];
CCHA(end) = [];
end