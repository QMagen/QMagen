function [ loss ] = loss_func( TStr, g, varagin )
loss = 0;
Model = GetModel(TStr, g, varagin);
load([TStr, 'exp_data.mat']);
% // Cm =======================================

RsltCv = cell(Cmdata.len, 1);
for i = 1:1:Cmdata.len
    clear Field
    Field.B = Cmdata.Field{i};
    [lossp, RsltCv{i}] = loss_func_Cm(Model, Field, Cmdata.Trange{i}, Cmdata.data{i});
    loss = loss + lossp;
end

RsltChi = cell(Chidata.len, 1);
for i = 1:1:Chidata.len
    Field.B = Chidata.Field{i};
    [lossp, RsltChi{i}] = loss_func_chi(Model, Field, Chidata.Trange{i}, Chidata.data{i});
    loss = loss + lossp;
end

global res_save
global min_loss_val
global res_save_name
global save_count
if res_save == 1
    if loss < min_loss_val
        save([res_save_pos, '.mat'], 'RsltCv', 'RsltChi');
        min_loss_val = loss;
    end
    
elseif res_save == 2
    save([res_save_name, num2str(save_count), '.mat'], 'RsltCv', 'RsltChi');
    save_count = save_count + 1;
end
end

