%% Path % Pamameters
clear
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master_BZ'))
cd('E:\5.CCEP')

FSFolder = 'E:\5.CCEP\2.CCEP_Freesurfer';
ResultsFolder = 'E:\5.CCEP\1.CCEP_Results_Final';
PatientID = 'PT002';
% Channel Inclusion
gLFile = [ResultsFolder filesep PatientID '_info\gL.mat'];
flagFile = [ResultsFolder filesep PatientID '_info\flag.mat'];

ssFile = [ResultsFolder filesep PatientID '\PTXXX_ss.mat'];
M_greyFile = [ResultsFolder filesep PatientID '\PTXXX_Matrix_grey.mat'];

% EIExcelFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PT005_Onset_EI.xlsx';
% ChanFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PTXXX_Channels.mat';

%% Create files for plot electrodes on the brain

global globalFsDir;
globalFsDir = FSFolder;

makeIniLocTxtFile(PatientID)
dykstraElecPjct(PatientID)

%% Load the data
load(gLFile)
load(flagFile)
load(ssFile)
load(M_greyFile)
%% Make derivatives
for i = 1:length(groupLabels)
    groupLabelsRaw{i,1} = groupLabels{i}(7:end);
end

% To load the included channel names using regular expression

% Make Channel information
Channels.EI = [];
Channels.tag = [];
for i = 1:length(txt)
    Ind1 = find(contains({Channels(:).id},txt{i}(2:end-1)));
    Channels(Ind1).EI = num(i,3);
    Channels(Ind1).tag = num(i,1);
end
    
IncludeCount = 0;
for i = find([Channels.keep])
    IncludeCount = IncludeCount + 1;
    [startIndex,~] = regexp(Channels(i).id,'\S\d');
    ChannelIncluded{IncludeCount,1} = Channels(i).id(startIndex(1) : startIndex(2) - 1);
    EIIncluded(IncludeCount,1) = Channels(i).EI;
    Categorization(IncludeCount,1) = Channels(i).tag;
end

%% %%%%%%% Plot the matrix %%%%%%%%%%%%%%


for i = 1:length(EIIncluded)
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        M_grey(i,ConnectElectrodes(a)) = nan;
    end
end

figure
pcolor(M_grey)
axis ij
colormap jet
imagesc(M_grey,'AlphaData',~isnan(M_grey))
colormap jet
grid on

%% %%%%%%%%%%%%% STIMULATION %%%%%%%%%%%%%%%%%%%%%%%

EvockedPotentials = [];
for i = 1:length(EIIncluded)
    
    ct1 = 0;
    % Identify electrode in one electrode shaft
    ElectrodeShaftName = ChannelIncluded{i}(isletter(ChannelIncluded{i}));
    ConnectElectrodes = find(~contains(ChannelIncluded,ElectrodeShaftName));
    for a = 1:length(ConnectElectrodes)
        ct1 = ct1 + 1;
        EvockedPotentials(ct1,i) = M_grey(i,ConnectElectrodes(a));
    end
end
figure
histogram(EvockedPotentials)
% M_grey = M_grey - min(EvockedPotentials);
% EvockedPotentials = EvockedPotentials - min(EvockedPotentials);

AbsMaxCCEP = max(EvockedPotentials(:));

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
    lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 8;
    cfg = [];
    cfg.view = 'romni';
    cfg.figId = 2;
    cfg.lineWidth = lineWidth;
    cfg.pairs = pairs;
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
    print(['Group-' num2str(Categorization(i)),'-', PatientID '-Stimulating-' ChannelIncluded{i}],'-r300','-dpng')
    
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
    lineWidth = (max([pairs{:,6}])/AbsMaxCCEP) * 8;
    cfg=[];
    cfg.view='romni';
    cfg.figId=2;
    cfg.lineWidth = lineWidth;
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
    print(['Group-' num2str(Categorization(i)),'-',PatientID '-Recording-' ChannelIncluded{i}],'-r300','-dpng')
    close 
    
end
cd ..

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







