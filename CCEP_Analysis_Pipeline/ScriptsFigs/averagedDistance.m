%%
clear
Folders = dir(pwd);
Folders = Folders(3:2:end);
Folders = {Folders.name}';


%%
for i = 1:25
    cd(Folders{i})
    % Load information
    load('PTXXX_Avg_MNI_Dis.mat')
    
    EZ2EZ(i,1)  = AvgDis.GroupEZ2EZ;
    EZ2PZ(i,1)  = AvgDis.GroupEZ2PZ;
    EZ2NIZ(i,1) = AvgDis.GroupEZ2NIZ;
    
    PZ2EZ(i,1)  = AvgDis.GroupPZ2EZ;
    PZ2PZ(i,1)  = AvgDis.GroupPZ2PZ;
    PZ2NIZ(i,1) = AvgDis.GroupPZ2NIZ;
    
    NIZ2EZ(i,1)  = AvgDis.GroupNIZ2EZ;
    NIZ2PZ(i,1)  = AvgDis.GroupNIZ2PZ;
    NIZ2NIZ(i,1) = AvgDis.GroupNIZ2NIZ;

    cd ..
end

%% 
%
EZStim = mean([EZ2EZ,EZ2PZ,EZ2NIZ],2);
PZStim = mean([PZ2EZ,PZ2PZ,PZ2NIZ],2);
NIZStim = mean([NIZ2EZ,NIZ2PZ,NIZ2NIZ],2);
%
EZRecord = mean([EZ2EZ,PZ2EZ,NIZ2EZ],2);
PZRecord = mean([EZ2PZ,PZ2PZ,NIZ2PZ],2);
NIZRecord = mean([EZ2NIZ,PZ2NIZ,NIZ2NIZ],2);












