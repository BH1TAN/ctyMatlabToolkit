function [spec,orgnSpecs] = getOrgnSeq(folderName,timeOf1File)
% ��ȡ������Ϊmatһ���ļ������е�spe����
% folderName: �ļ�������
% timeOf1File: ÿһ���ļ��Ĳ���ʱ������λ��s��
% orgnSpecs: ÿһ��Ϊһ���ļ���ԭʼ����
% spec: ���о���ƽ�����ף�����Ϊcps/ch
dir1=dir(folderName);

%% Ѱ�����׿�ͷ
specStartStr = '$DATA:';
fid = fopen([folderName,'\',dir1(3).name],'r');
for i =1:100 % ǰ100�����ҵ�����ͷ
    dataRow = fgetl(fid);
    if strncmp(dataRow,specStartStr,6)
        specStartRow = i;
        break;
    end
end
fclose(fid);

%% ����ԭʼ������orgnSpecs
orgnSpecs = [];
for i = 3:size(dir1,1)
    d = importdata([folderName,'\',dir1(i).name],'',specStartRow+1);
    if sum(d.data)~=0
        orgnSpecs = [orgnSpecs,d.data];
    end
    disp(num2str(i));
end
spec=sum(orgnSpecs,2)/(size(orgnSpecs,2)*timeOf1File);


% save(folderName,'orgnSpecs','spec');
% 
% figure;
% semilogy(spec);
% hold on;xlabel('Channel');ylabel('Count rate(cps/ch)');
% title(folderName);
% disp(['Count rate(count/1 file measure time):',num2str(sum(spec))]);
end