function [spec,sgnl] = getMat(folderName,header)
% Read spectra from .spe files and save to one matrix "sgnl"
% 
% Inputs:
% folderName: 
% header: Regular expression of interested file name. Example: CH0
% 
% Outputs:
% sgnl: each column is one spectrum, number of columns corresponds to the
% number of files in the folder whose name starts with header

dir1=dir([folderName,'\',header]);
sgnl = [];

%% Ѱ�����׿�ͷ
s = readspe([folderName,'\',dir1(3).name],specStartRow);
specStartRow = s.specStartRow;

%% ��������
% Ŀǰֻ�����кŵ������ף��Ժ�����Ҫ������readspe��ȫ������Ϣ
for i = 1:size(dir1,1)
    d = importdata([folderName,'\',dir1(i).name],'',specStartRow+1);
    if sum(d.data)~=0
        sgnl = [sgnl,d.data];
    end
    disp(num2str(i));
end

spec=sum(sgnl,2)/size(sgnl,2);

figure;
semilogy(spec);
hold on;xlabel('Channel');ylabel('Count rate(cnt/1 file measure time)');
grid on;
title(folderName);
disp(['Count rate(count/1 file measure time):',num2str(sum(spec))]);

header1=cell2mat(regexp(header,'[A-Z|a-z|0-9]','match'));%����ƥ�� �����ĸ+����
save([header1,'-',folderName],'sgnl','spec');

end