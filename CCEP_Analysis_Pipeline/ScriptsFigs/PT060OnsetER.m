cd('I:\CCEP_fig\PT060')
Raw = xlsread('PT060_Onset2_EI.xlsx',2)

EI = Raw(:,1)
load('D:\HFO_AI_Detector\ColorPalette\cdcol.mat')
figure
barh(EI,0.5,...
    'FaceColor',cdcol.lightgrey,...
    'EdgeColor',cdcol.lightgrey)
xlabel('EI')
axis ij
box off
hold on
yticklabels([])
yticks([])
line([0.3 0.3],[0 30],'Color',cdcol.burntsienna,'LineStyle','--','LineWidth',2)
set(gcf,'Position',[0 100 300 800])
print(['PT060_ER'],'-r600','-dpng')
close