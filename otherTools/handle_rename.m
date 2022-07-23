%% 按照excel表格为文件重命名
% 在需要重命名的文件同级目录下放置excel，两列，分别为旧文件名和新文件名
% 第一行为表头，内容任意

clear;close all;
mylist = readtable('文件重命名表.xlsx');
for i = 1:size(mylist,1)
    oldname = mylist{i,1}{1};
    newname = mylist{i,2}{1};
    eval(['!ren ',oldname,' ',newname]);
end