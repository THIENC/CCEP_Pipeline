%%
cd('E:\5.CCEP\1.CCEP_Results_Final')

%% connectivity
load('Results_Final.mat')
for i = 1:25
    Zscored(1,1,i) = EZ2EZ(i,1)
    Zscored(1,2,i) = EZ2PZ(i,1)
    Zscored(1,3,i) = EZ2NIZ(i,1)
    Zscored(2,1,i) = PZ2EZ(i,1)
    Zscored(2,2,i) = PZ2PZ(i,1)
    Zscored(2,3,i) = PZ2NIZ(i,1)
    Zscored(3,1,i) = NIZ2EZ(i,1)
    Zscored(3,2,i) = NIZ2PZ(i,1)
    Zscored(3,3,i) = NIZ2NIZ(i,1)
end


Outputname = 'Zscored.csv';


Zscore_R1 = squeeze(Zscored(1,1,:));
Zscore_R2 = squeeze(Zscored(1,2,:));
Zscore_R3 = squeeze(Zscored(1,3,:));
Zscore_R4 = squeeze(Zscored(2,1,:));
Zscore_R5 = squeeze(Zscored(2,2,:));
Zscore_R6 = squeeze(Zscored(2,3,:));
Zscore_R7 = squeeze(Zscored(3,1,:));
Zscore_R8 = squeeze(Zscored(3,2,:));
Zscore_R9 = squeeze(Zscored(3,3,:));

ZscoreFinal = [Zscore_R1;...
               Zscore_R2;...
               Zscore_R3;...
               Zscore_R4;...
               Zscore_R5;...
               Zscore_R6;...
               Zscore_R7;...
               Zscore_R8;...
               Zscore_R9];
           
Indx =  [repmat(1,[25,1]);...
               repmat(2,[25,1]);...
               repmat(3,[25,1]);...
               repmat(4,[25,1]);...
               repmat(5,[25,1]);...
               repmat(6,[25,1]);...
               repmat(7,[25,1]);...
               repmat(8,[25,1]);...
               repmat(9,[25,1])];

ZscoreFinal = [ZscoreFinal, Indx];

csvwrite(Outputname,ZscoreFinal)

%% Stimulating

Outputname = 'Stimulation.csv';
Stim = [EZStim,PZStim,NIZStim];
Stim_R = reshape(Stim,[numel(Stim), 1]);

Stim_R_F = [Stim_R, [repmat(1,[25,1]);repmat(2,[25,1]);repmat(3,[25,1])]]

csvwrite(Outputname,Stim_R_F)

%% Recording

Outputname = 'Recording.csv';
Record = [EZRecord,PZRecord,NIZRecord]
Record_R = reshape(Record,[numel(Record), 1]);

Record_R_F = [Record_R, [repmat(1,[25,1]);repmat(2,[25,1]);repmat(3,[25,1])]]

csvwrite(Outputname,Record_R_F)

%% 