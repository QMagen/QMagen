load Rslt.mat
load benchmark.mat
[omegams, qms] = meshgrid(Rslt.omega, Rslt.q ./ pi);
for i = 1:1:length(muRslt)
    Rslt.Co(i,:) = CoRslt{i};
end
[Szz_grid, k_grid, omega_grid] = zz_spectrum(64, 0, 1, 0:0.01:12, 0.4);

surf(k_grid(32:1:end,:)/pi, omega_grid(32:1:end,:), Szz_grid(32:1:end,:)/(max(reshape(Szz_grid, [numel(Szz_grid), 1]))), 'EdgeColor', 'none'); hold on
surf(qms, omegams, Rslt.Co/(max(reshape(Rslt.Co, [numel(Rslt.Co), 1]))), 'EdgeColor', 'none'); hold on
% surf(2-qms, omegams, Rslt.Co/(max(reshape(Rslt.Co, [numel(Rslt.Co), 1]))), 'EdgeColor', 'none'); hold on
% [omegamsp, qmsp] = meshgrid(Rslt.omega, 2 - Rslt.q ./ pi);
% contourf(qmsp, omegamsp, real(Sqw)/(max(reshape(real(Sqw), [numel(Sqw), 1])))); hold on
set(gca, 'FontSize', 15)
xlabel('k /\pi', 'FontSize', 20)
ylabel('\omega', 'FontSize', 20)
%text(0.4, 2.5, 'Che', 'Color', 'white', 'FontSize', 20)
%text(1.4, 2.5, 'ED', 'Color', 'white', 'FontSize', 20)
axis([0, 2, 0, 3])
hold off
% for i = 1:1:10
%     figure(i)
%     plot(Rslt.omega, Rslt.Co(i,:)/max(Rslt.Co(i,:)), '--', 'LineWidth', 2); hold on
%     plot(0:0.001:3, real(Sqw(i,:))/max(real(Sqw(i,:))), '-', 'LineWidth', 2); hold on
%     set(gca, 'FontSize', 15)
%     xlabel('\omega', 'FontSize', 20)
%     ylabel('S(k,\omega)', 'FontSize', 20)
%     legend({'Che', 'ED'}, 'FontSize', 20)
%     title({['k = ', num2str(Rslt.q(i)/pi), '\pi']}, 'FontSize', 20)
%     axis([0 3 0 1.1])
%     keyboard;
%     hold off
% end