function orgnSpecSeq = getOrgnSeq(folderName,displayOrNot)
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
orgnSpecSeq = [];
if displayOrNot
    f = waitbar(0,['Loading from folder ',folderName]);
end
for i = 3:size(dir1,1)
    d = importdata([folderName,'\',dir1(i).name],'',specStartRow+1);
    if sum(d.data)~=0
        orgnSpecSeq = [orgnSpecSeq,d.data];
    end
    if displayOrNot
        waitbar(i/size(dir1,1),f,['Loading ',num2str(i), ...
            '/',num2str(size(dir1,1)),' from folder ',folderName]);
    end
end
end