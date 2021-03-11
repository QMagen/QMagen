function [ Para ] = XTRGPara( Para )

Para.It = floor(log(Para.beta_max/Para.tau)/log(2));
Para.D_list = 1:1:Para.It;
Para.D_list(:) = 100;
Para.D_list(end:-1:end-4) = 200;

Para.MCrit = 200;
Para.VariProd_step_max = 10000;
Para.VariSum_step_max = 10000;
Para.SETTN_init_step_max = 10000;

end

