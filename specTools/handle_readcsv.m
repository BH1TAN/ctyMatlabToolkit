%% ��ȡ�ļ����ж��csv����
clear;
close all;
ch = 1;
dir1 = dir('*.csv');
for i = 1:length(dir1)
    s=readcsv(dir1(i).name);
    mat(:,i)=s.spec(:,ch);
end

save('afterbeam.mat','mat');
