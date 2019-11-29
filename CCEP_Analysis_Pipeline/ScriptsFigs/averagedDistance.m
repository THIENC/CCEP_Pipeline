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