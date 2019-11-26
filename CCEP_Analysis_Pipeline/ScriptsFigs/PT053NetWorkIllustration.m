%% Path
clear
cd('E:\5.CCEP\1.CCEP_Results_Final')
PatientID = 'PT005';
cd(PatientID)
%% Plot the matrix
load('PTXXX_Matrix_grey_Final_Sorted.mat')
load('PTXXX_Matrix_Channels_Final_Sorted.mat')

ChannelIncludedSorted1 = {ChannelsSorted.chan};
CategorizationSorted = [ChannelsSorted.tag];
EIIncludedSorted1 = [ChannelsSorted.EI];
figure
imagesc(M_greySorted1/max(M_greySorted1(:)),'AlphaData',~isnan(M_greySorted1))
% imagesc(M_greySorted1,'AlphaData',~isnan(M_greySorted1))
colormap jet
grid on
colorbar
xticks(1.5:size(M_greySorted1,1)+0.5)
yticks(1.5:size(M_greySorted1,2)+0.5)
xticklabels(ChannelIncludedSorted1)
yticklabels(ChannelIncludedSorted1)
xtickangle(90)
set(gca,'TickLength',[0 0])

title([PatientID '-SortedMatrix-' 'EZ-PZ-NIZ'])

ax = gca;
ax.LineWidth = 3;
axis square
% Make the seperating line for each group
hold on
%
line([0.5 size(M_greySorted1,1)+0.5],...
     [length(find(CategorizationSorted == 1)) + 0.5 length(find(CategorizationSorted == 1)) + 0.5],...
     'LineWidth',5,'Color','w','LineStyle','--')
line([0.5 size(M_greySorted1,1)+0.5],...
     [length(find(CategorizationSorted ~= 3)) + 0.5 length(find(CategorizationSorted ~= 3)) + 0.5],...
     'LineWidth',5,'Color','w','LineStyle','--')
%
line([length(find(CategorizationSorted == 1)) + 0.5 length(find(CategorizationSorted == 1)) + 0.5],...
     [0.5 size(M_greySorted1,1)+0.5],'LineWidth',5,'Color','w','LineStyle','--')
line([length(find(CategorizationSorted ~= 3)) + 0.5 length(find(CategorizationSorted ~= 3)) + 0.5],...
     [0.5 size(M_greySorted1,1)+0.5],'LineWidth',5,'Color','w','LineStyle','--')
set(gcf,'Position',[0 100 1000 1000])
caxis([0 0.6])
print([PatientID '_SortedMatrix_ColorScaled'],'-r600','-dpng')
close

%% Plot whole connectivity
for i = 1:length(groupLabels)
    groupLabelsRaw{i,1} = groupLabels{i}(7:end);
end

SideImp = 'r';
%%
pairs=[];
ct=0;
for i = 1:length(EIIncludedSorted1)
    for a = (i + 1) :length(EIIncludedSorted1)
        
        % Remove some empty pairs
        if isnan(M_greySorted1(i,a))
            continue
        end
        ct = ct + 1;
        pairs{ct,1} = ChannelIncludedSorted1{i};
        pairs{ct,2} = ChannelIncludedSorted1{a};
        pairs{ct,3} = [0.6 0.6 0.6 0.1]; % RGB val
        pairs{ct,4} = upper(SideImp);
        % pairs{ct,6} = nanmean([M_greySorted1(i,a),M_greySorted1(a,i)]);
        pairs{ct,6} = nanmean([M_greySorted1(i,a),M_greySorted1(a,i)]);
    end
end  
AbsMaxCCEP = max([pairs{:,6}]);
lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 30;
cfg = [];
cfg.view = [SideImp 'omni'];
%     cfg.figId = 2;
cfg.lineWidth = lineWidth;
cfg.pairs = pairs;
% Color the electrodes according to EI value
cfg.elecColors = EIIncludedSorted1;
cfg.elecColorScale = [0 1];
cfg.elecNames = ChannelIncludedSorted1;
%
cfg.elecShape = 'marker';
cfg.edgeBlack='n';
cfg.ignoreDepthElec='n';
cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncludedSorted1);
cfg.opaqueness=1;
cfg.showLabels='n';
cfg.elecUnits='EI';
cfg.title= [PatientID '-WholeBrain'];
cfgOut = plotPialSurf(PatientID,cfg);
set(gcf,'Position',[0 0 1920 1200])
%%
print([PatientID '-WholeBrain'],'-r600','-dpng')

close

%%