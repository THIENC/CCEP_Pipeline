function ChanLabels_New = Remove_Name_Pattern(Channel_Labels,Pattern)
%REMOVE_NAME_PATTERN Remove blanks in Channel names
%   Baotian @ Beijing 20180811
ChanLabels_New = cell(length(Channel_Labels),1);
for i = 1:length(Channel_Labels)
    temp = Channel_Labels{i};
    ChanLabels_New{i} = temp(~ismember(Channel_Labels{i},Pattern));
end
end