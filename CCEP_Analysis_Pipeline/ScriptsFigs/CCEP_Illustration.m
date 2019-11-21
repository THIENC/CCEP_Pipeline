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
cfg.elecNames = StimPair;
cfg.elecShape = 'marker';
cfg.edgeBlack ='n';
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

plot([Sw1;Sw2;Sw3;Sw4],'LineWidth',2,'Color',cdcol.lightblue)
ylabel('Amplitude')
xlabel('Time (¦Ìs)')
set(gcf,'Position',[0 100 600 600])
print(['SquareWaveStim'],'-r600','-dpng')
close

% Evoked potentials
cd('I:\CCEP_fig\CCEP_Raw_060\l5l6')

addpath('D:\THIENC_iEEG_Task_Preprocessing_Base\Externals\plotAreaErrorbar')
addpath('D:\spm12_7219')
spm('defaults','eeg')
D = spm_eeg_load();
EvokeChan = 77;
AllChan = [1:40];
BadChan = [40 38 32 29 26 20 17 13 6 5 1];
GoodChans = setdiff(AllChan,BadChan)
DataPlot = squeeze(D(EvokeChan,300:1000,GoodChans))';
h = figure(1)
rectangle('Position',[215 -70 285 180],'Curvature',0.2,'FaceColor',[0.5 0.5 0.5 0.2],'EdgeColor','none')
hold on
options.handle     = h;
options.color_area = [128 193 219]./255;    % Blue theme
options.color_line = [ 52 148 186]./255;
%options.color_area = [243 169 114]./255;    % Orange theme
%options.color_line = [236 112  22]./255;
options.alpha      = 0.5;
options.line_width = 3;
options.error      = 'sem';
box on
plot_areaerrorbar(DataPlot,options)
axis tight
set(gcf,'Position',[0 100 800 500])
print(['PT060_Sl56_Rf34'],'-r600','-dpng')
close


% figure
% for i = 1:40
%     figure
%     plot(squeeze(D(EvokeChan,300:1000,i)))
%     title(i)
% end





















