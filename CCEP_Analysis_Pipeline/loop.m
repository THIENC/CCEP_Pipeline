% loop for CCEP analysis

spm('defaults', 'EEG');
edfFiles = dir('*.edf');
for i = 1:1                      %length(edfFiles)
    mkdir(edfFiles(i).name(1:end-4));
    movefile(edfFiles(i).name,edfFiles(i).name(1:end-4));
    cd(edfFiles(i).name(1:end-4));
    %% File IO
    % load the raw edf data and convert it to SPM format
    D = edf_TO_SPM_converter_GUI([],[],'meeg_');

    % load and convert the DC channel
    DC = edf_TO_SPM_converter_GUI([],[],'DC_');

    %% rename the electrode
    D = spm_eeg_load();
    S.D = D;
    S.Channel_Labels_Raw = S.D.chanlabels';

    S.Channel_Labels_New = Deblank_Names(S.Channel_Labels_Raw);

    Pattern = '-Ref';
    S.Channel_Labels_New = Remove_Name_Pattern(S.Channel_Labels_New,Pattern);

    S.Channel_Labels_New = cellfun(@(x) x(3+1:end),S.Channel_Labels_New,'UniformOutput',false);

    S.D = struct(S.D);
    for i = 1:length(S.Channel_Labels_New)
       S.D.channels(i).label = S.Channel_Labels_New{i};
    end
    S.D = meeg(S.D);
    save(S.D);  

    %% Downsampling
    D = spm_eeg_load();
    % Downsample the data to 1000 if > 1000Hz
    if D.fsample > 1003
    clear S
    S.D = D;
    S.fsample_new = 1000;
    D = spm_eeg_downsample(S);
    end
    if DC.fsample > 1003
    clear S
    S.D = DC;
    S.fsample_new = 1000;
    DC = spm_eeg_downsample(S);
    end

    %% epoch
    timeStampNew = FindCCEPTriggers(DC);

    % define the trl
    for i = 1:length(timeStampNew)
    trl(i,1)=timeStampNew(i)*DC.fsample - 500;
    trl(i,2)=timeStampNew(i)*DC.fsample + 1000;
    trl(i,3)=-500;
    end

    % Epoching
    clear S
    S.D = D;
    S.bc = 0;
    S.trl = trl;
    S.prefix = 'e';
    D = spm_eeg_epochs(S);


    %% baseline correction
    clear S
    S.D = D;
    D = spm_eeg_bc(S);    % when epoching we have the negtive time , so dont need to set the timewindow


    %% filter
    clear S
    S.D = D;
    S.band = 'bandpass';
    S.freq = [1 300];
    D = spm_eeg_filter(S);

    %% Filter the signal 4 times, minimal preprocessing the raw resting data
    % 1st, 2nd, 3rd, 4th are bandstop around 50Hz, 100Hz, 150Hz, 200Hz
    % respectively
    for i = 1:4
    clear S
    S.D              = D;
    S.band           = 'stop';
    S.freq           = [50*i-3 50*i+3];
    S.order          = 5;
    S.prefix         = 'f';
    D = spm_eeg_filter(S);
    end


                     
    %% montage bipolar
    clear S
    S = D;
    D = SPM_bipolar_montage(S,'BipM_');

   cd ..
end