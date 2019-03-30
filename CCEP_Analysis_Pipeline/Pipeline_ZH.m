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

%define the trl
k_sample = D.fsample/1000;         %sampling rate is different!
for i = 1:40
    trl(i,1)=timeStampNew(i)-100*k_sample;
    trl(i,2)=timeStampNew(i)+300*k_sample;
    trl(i,3)=-100*k_sample;
end

%Epoching
D = spm_eeg_load();
S.D = D;
S.bc = 0;
S.trl = trl;
D = spm_eeg_epochs(S);





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

