clear all
clf
set(0, 'defaultfigurecolor', 'w')
load res.mat
InitTrace = res.ObjectiveTrace;
c = 1;
for i = 1:1:length(res.ObjectiveTrace)
    if InitTrace(i) < 0.9 * res.MinObjective
        Jxy(c,1) = table2array(res.XTrace(i,1));
        Jz(c,1) = table2array(res.XTrace(i,2));
        loss(c,1) = InitTrace(i);
        c = c + 1;
    end
end

bxp = boxplot([Jxy, Jz], 'Width', 0.5); hold on
% keyboard;
set(bxp, 'LineWidth', 1.5)
set(gca, 'YTick', 0:0.5:2)
axis([0.5, 2.5, 0, 2])
% plot([4.5, 4.5], [-0.4, 1.6], '--', 'color', [0.5, 0.5, 0.5], 'LineWidth', 3)
ylabel('Coupling strength (K)', 'FontSize', 25)
set(gca, 'fontname', 'Times New Roman', 'fontweight', 'Bold')

set(gca, 'FontSize', 23, 'LineWidth', 2)
set(gca, 'fontname', 'Times New Roman', 'fontweight', 'Bold')
set(gca, 'YGrid', 'on')
xticklabels({})
text(0.95, -0.13, '\itJ\rm\bf_{xy}', 'FontSize', 25, 'fontname', 'Times New Roman', 'fontweight', 'Bold')
text(1.95, -0.13, '\itJ\rm\bf_z', 'FontSize', 25, 'fontname', 'Times New Roman', 'fontweight', 'Bold')