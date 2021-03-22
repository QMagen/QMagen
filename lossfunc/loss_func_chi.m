function [ loss, Rslt ] = loss_func_chi( QMagenConf, Trange,  Chi_data, loss_type )
loss = 0;

T_exp = Chi_data(:,1);
chi_exp = Chi_data(:,2);
T_min = max(min(T_exp), Trange(1));
T_max = min(max(T_exp), Trange(2));

ThDQ = 'Chi';

[~, Rslt] = GetResult(QMagenConf, 0.9 * T_min, ThDQ);
T = Rslt.T_l;
chi = Rslt.Chi_l;

for i = 1:length(T)
    if T(end) < T_min
        T(end) = [];
        chi(end) = [];
    else
        break;
    end
end

while 1
    if T(1) > T_max
        T(1) = [];
        chi(1) = [];
    else
        break;
    end
end

chi_int = interp1(T_exp, chi_exp, T);

switch loss_type
    case 'abs-err'
        for i = 1:length(T)
            loss = loss + (chi_int(i) - chi(i))^2; 
        end
        loss = loss / max(chi_int)^2;
    case 'rel-err'
        for i = 1:length(T)
            loss = loss + ((chi_int(i) - chi(i))/chi_int(i))^2; 
        end
end

loss = loss/length(T);
global PLOTFLAG
if PLOTFLAG == 1
    hold off
    figure(3)
    semilogx(T_exp, chi_exp, 'LineWidth', 2); hold on
    semilogx(T, chi, '-*', 'LineWidth', 2);
    set(gca, 'FontSize', 15)
    legend({'exp', 'sim'}, 'FontSize', 20);
    xlabel('T (K)', 'FontSize' ,20);
    ylabel('cm^3/mol', 'FontSize', 20);
    % axis([0.01 T_max+1 0 max(chi_int) * 1.1]);
    saveas(gcf, 'chi.png')
    hold off
end
end

