function [ UnitCon ] = GetUnitCon(para)
% TMGO
% \\Constant---------------------------------------------------------
Const.kb = 8.617e-2;
Const.MJ = 1.602e-22;
Const.mu_b = 9.274e-24;
Const.R = 8.31446;
Const.NA = 6.022e23;
Const.mu_0 = 4 * pi * 10^(-7);

% \\Energy Scaling---------------------------------------------------
UnitCon.T_con = para.Model.ES;
ES = para.Model.ES;

% \\Heat capacity----------------------------------------------------
UnitCon.Cm_con = Const.R;

% \\Field Strength---------------------------------------------------
try
    g = para.Model.g;
catch
    g = [2,2,2];
end
h_con = g;
for i = 1:1:3
    h_con(i) = ES * Const.kb * Const.MJ / g(i) / Const.mu_b;
end
UnitCon.h_con = h_con;

% \\Susceptibility emu/(g Oe)/geff^2---------------------------------
% Chi_con(i) = Const.NA * Const.mu_0 * (Const.mu_b)^2 / ...
%              (ES * Const.kb * Const.MJ) * 10^6 / Const.mass / (4 * pi);
% UnitCon.Chi_con = Chi_con;
     
% \\Susceptibility cm^3/mol/geff^2 (SI unit)-------------------------
Chi_con = Const.NA * Const.mu_0 * (Const.mu_b)^2 / ...
             (ES * Const.kb * Const.MJ) * 10^6;
UnitCon.Chi_con = Chi_con;

% save(['tmp'])


end