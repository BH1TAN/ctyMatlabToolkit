%% ��׼��.mat�е�sgnl���ײ�������"*-nml.mat"��
% �޸�uncaliMatName ����ֱ������
% ����չʾ��ROI�����⣬��������0ֹͣ�������޸�caliParam
clear;close all;
delOrNot = 1; % �Ƿ�ɾ������Ŀ¼���Ѵ��ڵ���nml��β�ı�׼���ļ�
plotOrNot = 1; % �Ƿ���ϵ�ͼ
unNmlMatName = 'orgn.mat';
caliParam.maxE = 12; % MeV
caliParam.EStep = 0.01; % MeV
caliParam.tPerFile = 8*60; % ���ÿ�����ײ��ã�����ɾ����С�����ֵ����λs
caliParam.E(1,1) = 2.223;caliParam.Ewin(1,:) = [1437,1700];
%caliParam.E(2,1) = 4.945;caliParam.Ewin(2,:) = [1632,1705];
%caliParam.E(3,1) = 7.638;caliParam.Ewin(3,:) = [2691,2823];
caliParam.E(2,1) = 7.638;caliParam.Ewin(2,:) = [5173,5547];
%caliParam.E(3,1) = 0.478;caliParam.Ewin(3,:) = [145,201];

%% ɾ���ɵı�׼������
% if delOrNot
%     delete('*-nml.mat');
% end

%% ����ʾ�����װ����ж��ܷ�����
fileList = dir(unNmlMatName);
load(fileList(1).name);
thisSpec = sum(sgnl,2)/size(sgnl,2);
thisSpec1 = sgnl(:,1);
semilogy(thisSpec,'b.-');hold on; xlabel('Channel');ylabel('Count rate');
semilogy(thisSpec1,'g.-');hold on; xlabel('Channel');ylabel('Count rate');
title({'Sample spectrum showing ROIs which are used for calibration';fileList(1).name});
for i = 1:length(caliParam.E)
    winwin = caliParam.Ewin(i,1):caliParam.Ewin(i,2);
    semilogy(winwin,thisSpec(winwin),'r.-');
    semilogy(winwin,thisSpec1(winwin),'r.-');
    text(winwin(1), ...
        2*max(thisSpec(winwin))-min(thisSpec(winwin)), ...
        num2str(caliParam.E(i)),'Color','r');
end
hold off;

%% ����ʾ��ROI�����Ƿ��׼��
tmp = input('Accept(enter) or not(any number): ');
if isempty(tmp) % ͬ��ROI���ɼ�������
    for i = 1:size(fileList,1)
        thisName = fileList(i).name;
        load(thisName,'sgnl');
        [sgnl,eAxisOld,eAxisNew] = nmlAndSave1Mat(sgnl,caliParam,plotOrNot);
        if plotOrNot
            title(fileList(i).name);
        end
        disp(['Processed:',fileList(i).name]);
        save([thisName(1:length(thisName)-4), ...
            '-step',num2str(caliParam.EStep),'MeV-nml.mat',],'sgnl','eAxisOld','eAxisNew');
    end
    disp('Success: task done');
else % ��ͬ��ROI������������
    disp('Warning: task terminate because of user veto ROI');
    return;
end
