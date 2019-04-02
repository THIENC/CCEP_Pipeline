spm('defaults', 'EEG');
% load the raw edf data and convert it to SPM format
D = edf_TO_SPM_converter_GUI([],[],'meeg_');

% load and convert the DC channel
D = edf_TO_SPM_converter_GUI([],[],'DC_');

% find the trigger
D = spm_eeg_load();
TriggerChannel = D(:);
% Binarize
maxTrigger = max(TriggerChannel);
threshold = 0.3*maxTrigger;
BinTrigger = (TriggerChannel >= threshold);
timeStamps = diff(BinTrigger);
timeStampNew = find(timeStamps == 1);

% define the trl
k_sample = D.fsample/1000;         %sampling rate is different!
for i = 1:40
    trl(i,1)=timeStampNew(i)-100*k_sample;
    trl(i,2)=timeStampNew(i)+300*k_sample;
    trl(i,3)=-100*k_sample;
end

% Epoching
D = spm_eeg_load();
S.D = D;
S.bc = 0;
S.trl = trl;
D = spm_eeg_epochs(S);

% filter
S.D = D;
S.band = 'bandpass';
S.freq = [1 300];
D = spm_eeg_filter(S);

% baseline correction
S.D = D;
D = spm_eeg_bc(S);    % when epoching we have the negtive time , so dont need to set the timewindow

% rename the electrode
Channel_Renaming_UI;  

                     % then delete the '-Ref' artificially

% montage bipolar
S = D;
D = SPM_bipolar_montage(S,'BipM_');






for i = 1:10000
    B(i)=i;
end
B = clone(D,'E:\mat\copy.mat');
figure
plot(B(:));
S.D = B;
S.bc = 0;

S.trl =[1000 2000 -200;3000 4000 -200];
D = spm_eeg_epochs(S);
figure;
plot(D(1,:,1));

S.trl =[1000 2000;3000 4000];
D = spm_eeg_epochs(S);
figure;
plot(D(1,:,1));



D = spm_eeg_load();
for i = 1:133 
ChannelInd = i;
Data = squeeze(D(ChannelInd,:,:));
figure
plot(Data)
axis tight
end
idx = kmeans(Data',2)

figure
hold on
for i = 1:40
    if idx(i) == 1
        plot(Data(:,i),'r')
    elseif idx(i) == 2
        plot(Data(:,i),'g')
    end
end
