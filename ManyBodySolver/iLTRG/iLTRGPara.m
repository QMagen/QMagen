function [Para] = iLTRGPara( Para )

Para.tau = 0.025;
Para.N_max = floor(Para.beta_max / 2 / Para.tau) + 3;
%---------------------------------RG--------------------------------%
Para.S = 2;             % S = 2s+1;
Para.TroOrd = '1';      % '1' only
Para.D_max = 40;

end