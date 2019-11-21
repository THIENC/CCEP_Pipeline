%% Path

cd('I:\CCEP_fig\FS')
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master_BZ'))

%% Plot the brain 
%%%%%%%%%%% CHANGE PATIENT ID HERE!!! %%%%%%%%%%
PatientID = 'PT060';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global globalFsDir;
globalFsDir='I:\CCEP_fig\FS';
cd(globalFsDir)

makeIniLocTxtFile(PatientID)
dykstraElecPjct(PatientID)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eleColors = rand([108,1]);
%% Information for plot
% To load the selected channels
load('I:\CCEP_fig\CCEP_Raw_060\PT060_info\gL.mat')
load('I:\CCEP_fig\CCEP_Raw_060\PT060_info\flag.mat')
for i = 1:length(groupLabels)
    groupLabelsRaw{i,1} = groupLabels{i}(7:end);
end

% To load the included channel names using regular expression
load('I:\CCEP_fig\CCEP_Raw_060\PTXXX_Channels.mat')
IncludeCount = 0;
for i = find([Channels.keep])
    IncludeCount = IncludeCount + 1;
    [startIndex,~] = regexp(Channels(i).id,'\S\d');
    ChannelIncluded{IncludeCount,1} = Channels(i).id(startIndex(1) : startIndex(2) - 1);
    EIIncluded(IncludeCount,1) = Channels(i).EI;
    Categorization(IncludeCount,1) = Channels(i).tag;
end

%% %%%%%%%%%%%%% STIMULATION %%%%%%%%%%%%%%%%%%%%%%%
mkdir('Stimulation')
cd('Stimulation')
for i = 1:length(EIIncluded)
    pairs=[];
    ct=0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct = ct + 1;
        pairs{ct,1} = ChannelIncluded{i};
        pairs{ct,2} = ChannelIncluded{ConnectElectrodes(a)};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = 'R';
        pairs{ct,6} = M_grey(i,ConnectElectrodes(a));
    end
end

AbsMaxCCEP = 


for i = 1:length(EIIncluded)
    pairs=[];
    ct=0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct = ct + 1;
        pairs{ct,1} = ChannelIncluded{i};
        pairs{ct,2} = ChannelIncluded{ConnectElectrodes(a)};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = 'R';
        pairs{ct,6} = M_grey(i,ConnectElectrodes(a));
    end
    
    cfg=[];
    cfg.view='romni';
    cfg.figId=2;
    cfg.lineWidth = 8;
    cfg.pairs=pairs;
    % Color the electrodes according to EI value
    cfg.elecColors = EIIncluded;
    cfg.elecColorScale = [0 1];
    cfg.elecNames = ChannelIncluded;
    % 
    cfg.elecShape = 'marker';
    cfg.edgeBlack='n';
    cfg.ignoreDepthElec='n';
    cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncluded);
    cfg.opaqueness=0.03;
    cfg.showLabels='n';
    cfg.elecUnits='EI';
    cfg.title= [PatientID '-Stimulating-' ChannelIncluded{i} '-Group-' num2str(Categorization(i))];
    cfgOut = plotPialSurf(PatientID,cfg);
    set(gcf,'Position',[0 0 1920 1200])
    print([PatientID 'Stimulating' ChannelIncluded{i}],'-r300','-dpng')
    
    close 
    
end
cd ..

%% %%%%%%%%%%%%% RECORDING %%%%%%%%%%%%%%%%%%%%%%%
mkdir('Recording')
cd('Recording')
for i = 1:length(EIIncluded)
    pairs=[];
    ct=0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct = ct + 1;
        pairs{ct,1} = ChannelIncluded{i};
        pairs{ct,2} = ChannelIncluded{ConnectElectrodes(a)};
        pairs{ct,3} = [0.6 0.6 0.6]; % RGB val
        pairs{ct,4} = 'R';
        pairs{ct,6} = M_grey(ConnectElectrodes(a),i);
    end
    
    cfg=[];
    cfg.view='romni';
    cfg.figId=2;
    cfg.lineWidth = 8;
    cfg.pairs=pairs;
    % Color the electrodes according to EI value
    cfg.elecColors = EIIncluded;
    cfg.elecColorScale = [0 1];
    cfg.elecNames = ChannelIncluded;
    % 
    cfg.elecShape = 'marker';
    cfg.edgeBlack='n';
    cfg.ignoreDepthElec='n';
    cfg.ignoreChans = setdiff(groupLabelsRaw,ChannelIncluded);
    cfg.opaqueness=0.03;
    cfg.showLabels='n';
    cfg.elecUnits='EI';
    cfg.title= [PatientID '-Recording-' ChannelIncluded{i} '-Group-' num2str(Categorization(i))];
    cfgOut = plotPialSurf(PatientID,cfg);
    set(gcf,'Position',[0 0 1920 1200])
    print([PatientID 'Recording' ChannelIncluded{i}],'-r300','-dpng')
    close 
    
end
cd ..

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test Aera

figure
imagesc(M_grey)

M_grey(3,5:10) = nan;
figure
imshow(M_grey)
figure
imagesc(M_grey,'AlphaData',~isnan(M_grey))








StimPair = {'l5','l6','f3','f4'};
cfg=[];
cfg.view='r';
cfg.elecColors = [cdcol.carmine;cdcol.carmine;cdcol.emeraldgreen;cdcol.emeraldgreen];
cfg.elecColorScale=[0 1];
cfg.elecNames= StimPair;
cfg.elecShape = 'marker';
cfg.edgeBlack='n';
cfg.ignoreDepthElec='n';
cfg.opaqueness=0.2;

cfg.title= PatientID;
cfgOut=plotPialSurf(PatientID,cfg);





