function [ loss, Rslt ] = loss_func_Cm( Model, Field, Trange, C_data )
loss = 0;
T_exp = C_data(:,1);
C_exp = C_data(:,2);

T_min = max(min(T_exp), Trange(1));
T_max = min(max(T_exp), Trange(2));

ThDQ = 'Cm';
[~, Rslt] = GetResult(Model, Field, T_min-0.1 * T_min, ThDQ);
% keyboard;
T = Rslt.T_l;
C = Rslt.Cm_l;
% T(1) = [];
% T(end) = [];
% C(1) = [];
% C(end) = [];

for i = 1:length(T)
    if T(end) < T_min
        T(end) = [];
        C(end) = [];
    else
        break;
    end
end

while 1
    if T(1) > T_max
        T(1) = [];
        C(1) = [];
    else
        break;
    end
end
% keyboard;
C_int = interp1(T_exp, C_exp, T);
for i = 1:length(T)
    loss = loss + ((C_int(i) - C(i))/C_int(i))^2; 
end
loss = loss/length(T);
global plot_check
if plot_check == 1
    semilogx(T_exp, C_exp, 'LineWidth', 2); hold on
    plot(T, C, '*', 'LineWidth', 2);
    set(gca, 'FontSize', 15);
    legend({'exp', 'YC6*9_Li_200'}, 'FontSize', 20);
    xlabel('T (K)', 'FontSize', 20);
    ylabel('Cm (J/mol K)', 'FontSize', 20);
    axis([0.1 T_max+1 0 3])
    saveas(gcf, 'C.png')
    hold off
end
end

