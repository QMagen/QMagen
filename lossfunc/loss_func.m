function [ loss ] = loss_func( TStr, g, varagin )
loss = 0;
load(['tmp_', TStr, '/exp_data.mat']);
load(['tmp_', TStr, '/configuration.mat'])

loss_type = lossconfig.loss_type;
loss_design = lossconfig.loss_design;
wl = lossconfig.weight_list;

if isempty(wl)
    wl = zeros(Cmdata.len + Chidata.len, 1);
    wl(:) = 1;
end

% // Cm =======================================

RsltCv = cell(Cmdata.len, 1);
for i = 1:1:Cmdata.len
    clear Field
    Field.B = Cmdata.Field{i};
    switch ModelConf.g_def
        case 'xyz'
            g_fec = [0, 0, 0];
            for j = 1:1:ModelConf.g_len
                g_fec = g_fec + g(j) * ModelConf.g_vec{j};
            end
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
        case 'dir'
            g_fec = g(Cmdata.g_info{i}) * ModelConf.g_vec{Cmdata.g_info{i}};
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
    end
    Model = GetModel(TStr, g_fec, varagin);
    [lossp, RsltCv{i}] = loss_func_Cm(Model, Field, Cmdata.Trange{i}, Cmdata.data{i}, loss_type);
    loss = loss + lossp * wl(i);
end

% // chi ======================================

RsltChi = cell(Chidata.len, 1);
for i = 1:1:Chidata.len
    Field.B = Chidata.Field{i};
    switch ModelConf.g_def
        case 'xyz'
            g_fec = [0, 0, 0];
            for j = 1:1:ModelConf.g_len
                g_fec = g_fec + g(j) * ModelConf.g_vec{j};
            end
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
        case 'dir'
            g_fec = g(Cmdata.g_info{i}) * ModelConf.g_vec{Chidata.g_info{i}};
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
    end
    Model = GetModel(TStr, g_fec, varagin);
    [lossp, RsltChi{i}] = loss_func_chi(Model, Field, Chidata.Trange{i}, Chidata.data{i}, loss_type);
    loss = loss + lossp * wl(i + Cmdata.len);
end

switch loss_design
    case 'native'
    case 'log'
        loss = log(loss);
    otherwise
        keyboard;
end

global res_save
global min_loss_val
global res_save_name
global save_count
if res_save == 1
    if loss < min_loss_val
        save(res_save_name, 'best.mat', 'RsltCv', 'RsltChi');
        min_loss_val = loss;
    end
    
elseif res_save == 2
    save([res_save_name, num2str(save_count), '.mat'], 'RsltCv', 'RsltChi');
    save_count = save_count + 1;
end
end

