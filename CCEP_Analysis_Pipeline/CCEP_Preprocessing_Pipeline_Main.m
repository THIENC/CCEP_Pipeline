% Initializing SPM
spm('defaults', 'EEG');
% load the raw edf data and convert it to SPM format
D = edf_TO_SPM_converter_GUI([],[],'meeg_');
% load and convert the DC channel
D = edf_TO_SPM_converter_GUI([],[],'DC_');

D = spm_eeg_load();

data = D(4:10,:)';
plotECG(data,'AutoStackSignals',{'I','II','III', 'aVR','aVL','aVF', 'V1'})

