function [ Para ] = XTRGPara( Para )

% //D: bond dimension of rho(beta)
% It: XTRG iterations
% D_list = [Di for i steps, Dj for j steps, etc .]
Para.It = floor(log(Para.beta_max/Para.tau)/log(2));
Para.D_list = 1:1:Para.It;
Para.D_list(:) = 50;
Para.D_list(end:-1:end-4) = 50;

% //MCrit: bond dimension compressing H^n
% used in SETTN initialization of rho(tau)
Para.MCrit = 50;  

% //XTRG runtime parameters
Para.VariProd_step_max = 10000;
Para.VariSum_step_max = 10000;
Para.SETTN_init_step_max = 10000;

end

