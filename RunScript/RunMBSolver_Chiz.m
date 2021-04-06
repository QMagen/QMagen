clear all
addpath(genpath('../'))
maxNumCompThreads(4);
% =========================================================================
Config.ManyBodySolver = 'iLTRG'; % 'ED', 'iLTRG', 'XTRG'
Config.ModelName = 'XYZC';
Config.Mode = 'CALC-Chi';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ Lattice, ModelConf, Config ] = GetSpinModel( Config );

% // set the field to calculate
Field.h = [0, 0, 0.1];

QMagenConf = QMagen(Config, ModelConf, Lattice, Field);

Jy_l = -2:0.5:2;
lenJy = length(Jy_l);
Jz_l = -2:0.5:2;
lenJz = length(Jz_l);

RsltChi = cell(lenJy, lenJz);

for i = 1:1:lenJy
    for j = 1:1:lenJz
        % // set the parameter value to calculate
        QMagenConf = GetModel(QMagenConf, 'Jx', 1, ...
                                          'Jy', Jy_l(i), ...
                                          'Jz', Jz_l(j));
        
        [RsltChi{i,j}]=QMagenMain(QMagenConf, 'Kmin', 0.1);
    end
end
save('ChizRslt.mat', 'RsltChi');