% load('res_YC46_200.mat')
clear all
load res5_re-err.mat
InitTrace = res.ObjectiveTrace;
c = 1;
for i = 1:1:2000
    if InitTrace(i) < -1.44
        J1xy(c,1) = table2array(res.XTrace(i,1));
        J1z(c,1) = table2array(res.XTrace(i,2));
        JPD(c,1) = table2array(res.XTrace(i,3));
        JGamma(c,1) = table2array(res.XTrace(i,4));
        gx(c,1) = table2array(res.XTrace(i,5));
        gz(c,1) = table2array(res.XTrace(i,6));
        loss(c,1) = InitTrace(i);
        c = c + 1;
    end
end
InitTable = table(J1xy, J1z, JPD, JGamma, gx, gz, loss);
% save('YC46Init.mat', 'InitTable')