%% Path % Pamameters
clear
FSFolder = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005';
PatientID = 'PT005';
gLFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PT005_info\gL.mat';
flagFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PT005_info\flag.mat';
EIExcelFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PT005_Onset_EI.xlsx';
ChanFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PTXXX_Channels.mat';
M_greyFile = 'C:\Users\su_fe\Desktop\20190429_CCEP_Projects\Data\PT005\PTXXX_Matrix_grey.mat';

cd(FSFolder)
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master_BZ'))

%% Plot the brain 
%%%%%%%%%%% CHANGE PATIENT ID HERE!!! %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global globalFsDir;
globalFsDir=FSFolder;
cd(globalFsDir)

makeIniLocTxtFile(PatientID)
dykstraElecPjct(PatientID)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eleColors = rand([108,1]);
%% Information for plot
% To load the selected channels
load(gLFile)
load(flagFile)
for i = 1:length(groupLabels)
    groupLabelsRaw{i,1} = groupLabels{i}(7:end);
end

% To load the included channel names using regular expression
load(ChanFile)
[num,txt,~] = xlsread(EIExcelFile);
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

%% %%%%%%%%%%%%% STIMULATION %%%%%%%%%%%%%%%%%%%%%%%

load(M_greyFile)
% M_grey = log(M_grey);
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





