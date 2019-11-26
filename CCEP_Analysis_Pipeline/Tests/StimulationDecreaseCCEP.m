%% Path
addpath('D:\spm12_7219')
spm('defaults','eeg')
%% PT002
% S:A1-A2       R: U1-U2
cd('J:\CCEP\CCEP_Raw_002\A1A2')
D = spm_eeg_load();
i = 25;

for i = 1:length(D.chanlabels)
    ChannelInd = i;
    Data = squeeze(D(ChannelInd,:,:));
    figure
    for j = 1:D.ntrials
        ColorJet = flipud(jet(D.ntrials));
        %         plot(D.time,Data(:,j),'Color',[1 1 1]/j);
        plot(D.time,Data(:,j),'Color',ColorJet(j,:));
        hold on
    end
    grid on
    % plot(D.time,mean(Data,2),'LineWidth',2,'Color','r','LineStyle','--')

    title(D.chanlabels(i));
    set(gca,'FontSize',14)

    set(gcf,'Position',[0 100 1920 600])
    colorbar
    colormap('jet')
    print(D.chanlabels{i},'-dpng')
    close
end


%% PT003

% S:A2-A3       R: F6-F7
cd('J:\CCEP\CCEP_Raw_003\A2A3')
D = spm_eeg_load();
i = 121;

for i = 1:length(D.chanlabels)
    ChannelInd = i;
    Data = squeeze(D(ChannelInd,:,:));
    figure
    for j = 1:D.ntrials
        ColorJet = flipud(jet(D.ntrials));
        %         plot(D.time,Data(:,j),'Color',[1 1 1]/j);
        plot(D.time,Data(:,j),'Color',ColorJet(j,:));
        hold on
    end
    grid on
    % plot(D.time,mean(Data,2),'LineWidth',2,'Color','r','LineStyle','--')

    title(D.chanlabels(i));
    set(gca,'FontSize',14)

    set(gcf,'Position',[0 100 1920 600])
    colorbar
    colormap('jet')
    print(D.chanlabels{i},'-dpng')
    close
end

%% PT008
cd('J:\CCEP\CCEP_Raw_008\a1a2')
D = spm_eeg_load();
i = 91;

for i = 1:length(D.chanlabels)
    ChannelInd = i;
    Data = squeeze(D(ChannelInd,:,:));
    figure
    for j = 1:D.ntrials
        ColorJet = flipud(jet(D.ntrials));
        %         plot(D.time,Data(:,j),'Color',[1 1 1]/j);
        plot(D.time,Data(:,j),'Color',ColorJet(j,:));
        hold on
    end
    grid on
    % plot(D.time,mean(Data,2),'LineWidth',2,'Color','r','LineStyle','--')

    title(D.chanlabels(i));
    set(gca,'FontSize',14)

    set(gcf,'Position',[0 100 1920 600])
    colorbar
    colormap('jet')
    print(D.chanlabels{i},'-dpng')
    close
end

%% PT058

cd('J:\CCEP\CCEP_Raw_059\A2A3')
D = spm_eeg_load();
i = 47;

for i = 1:length(D.chanlabels)
    ChannelInd = i;
    Data = squeeze(D(ChannelInd,:,:));
    figure
    for j = 1:D.ntrials
        ColorJet = flipud(jet(D.ntrials));
        %         plot(D.time,Data(:,j),'Color',[1 1 1]/j);
        plot(D.time,Data(:,j),'Color',ColorJet(j,:));
        hold on
    end
    grid on
    % plot(D.time,mean(Data,2),'LineWidth',2,'Color','r','LineStyle','--')

    title(D.chanlabels(i));
    set(gca,'FontSize',14)

    set(gcf,'Position',[0 100 1920 600])
    colorbar
    colormap('jet')
    print(D.chanlabels{i},'-dpng')
    close
end

%% PT058

cd('J:\CCEP\CCEP_Raw_058\A2A3')
D = spm_eeg_load();
i = 48;

for i = 1:length(D.chanlabels)
    ChannelInd = i;
    Data = squeeze(D(ChannelInd,:,:));
    figure
    for j = 1:D.ntrials
        ColorJet = flipud(jet(D.ntrials));
        %         plot(D.time,Data(:,j),'Color',[1 1 1]/j);
        plot(D.time,Data(:,j),'Color',ColorJet(j,:));
        hold on
    end
    grid on
    % plot(D.time,mean(Data,2),'LineWidth',2,'Color','r','LineStyle','--')

    title(D.chanlabels(i));
    set(gca,'FontSize',14)

    set(gcf,'Position',[0 100 1920 600])
    colorbar
    colormap('jet')
    print(D.chanlabels{i},'-dpng')
    close
end
%% PT057

cd('J:\CCEP\CCEP_Raw_057\AO1AO2')
D = spm_eeg_load();
i = 17;

for i = 1:length(D.chanlabels)
    ChannelInd = i;
    Data = squeeze(D(ChannelInd,:,:));
    figure
    for j = 1:D.ntrials
        ColorJet = flipud(jet(D.ntrials));
        %         plot(D.time,Data(:,j),'Color',[1 1 1]/j);
        plot(D.time,Data(:,j),'Color',ColorJet(j,:));
        hold on
    end
    grid on
    % plot(D.time,mean(Data,2),'LineWidth',2,'Color','r','LineStyle','--')

    title(D.chanlabels(i));
    set(gca,'FontSize',14)

    set(gcf,'Position',[0 100 1920 600])
    colorbar
    colormap('jet')
    print(D.chanlabels{i},'-dpng')
    close
end
figure
plot(D.time,mean(Data(:,1:20),2),'Color','r');
hold on
plot(D.time,mean(Data(:,21:end),2),'Color','b');
%%



