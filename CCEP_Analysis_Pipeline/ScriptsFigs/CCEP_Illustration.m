cd('I:\CCEP_fig\FS')
addpath(genpath('C:\Users\su_fe\Desktop\iELVis-master'))

%% Plot the brain 
%%%%%%%%%%% CHANGE PATIENT ID HERE!!! %%%%%%%%%%
PatientID = 'PT060';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global globalFsDir;
globalFsDir='I:\CCEP_fig\FS';
cd(globalFsDir)

% cd(PatientID)
% cfg=[]; cfg.printFigs=1;
% plotMgridOnSlices(PatientID,cfg);
makeIniLocTxtFile(PatientID)
dykstraElecPjct(PatientID)
load('D:\HFO_AI_Detector\ColorPalette\cdcol.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eleColors = rand([108,1]);
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% groupAvgCoords=[];
% groupLabels=[];
% groupIsLeft=[];
% 
% cfg=[];
% subs={'PT060'};
% for a=1:length(subs),
% fprintf('Working on Participant %s\n',subs{a});
% [avgCoords, elecNames, isLeft]=sub2AvgBrain(subs{a},cfg);
% groupAvgCoords=[groupAvgCoords; avgCoords];
% groupLabels=[groupLabels; elecNames];
% groupIsLeft=[groupIsLeft; isLeft];
% end


%% Plot evoked potentials
% PT060 S: l5l6 R:f3f4
% square wave

figure
squareWave = square(t);
Sw1 = ones([2000 1]);
Sw2 = ones([1000 1]) + 1;
Sw3 = ones([1000 1]) - 1;
Sw4 = ones([2000 1]);

plot([Sw1;Sw2;Sw3;Sw4],'LineWidth',2)
axis off
set(gcf,'Position',[0 100 300 500])
print(['SquareWaveStim'],'-r600','-dpng')
close



















