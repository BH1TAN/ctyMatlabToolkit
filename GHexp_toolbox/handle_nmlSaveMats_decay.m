%% ��׼��.mat�е�spec���ײ�������"*-nml.mat"��
% �޸�uncaliMatName ����ֱ������
% ����չʾ��ROI�����⣬��������0ֹͣ�������޸�caliParam
clear;close all;
caliParam.EStep = 0.0001; % MeV
caliParam.maxE = 12;
delOrNot = 1; % �Ƿ�ɾ������Ŀ¼���Ѵ��ڵ���nml��β�ı�׼���ļ�
plotOrNot = 1; % �Ƿ���ϵ�ͼ
unNmlMatName = 'spec.mat';
caliParam.tPerFile = 60;

caliParam.E(1,1) = 1.46082;caliParam.Ewin(1,:) = [3355,3399];
caliParam.E(2,1) = 2.614511;caliParam.Ewin(2,:) = [6024,6077];

%% ɾ���ɵı�׼������
if delOrNot
    delete('*-nml.mat');
end

%% ����ʾ�����װ����ж��ܷ�����
fileList = dir(unNmlMatName);
load(fileList(1).name);
thisSpec = sgnl(:,1);
semilogy(thisSpec,'b.-');hold on; xlabel('Channel');ylabel('Count');
title({'Sample spectrum showing ROIs which are used for calibration';fileList(1).name});
for i = 1:length(caliParam.E)
    winwin = caliParam.Ewin(i,1):caliParam.Ewin(i,2);
    semilogy(winwin,thisSpec(winwin),'r.-');
    text(winwin(1), ...
        2*max(thisSpec(winwin))-min(thisSpec(winwin)), ...
        num2str(caliParam.E(i)),'Color','r');
end
hold off;

%% ����ʾ��ROI�����Ƿ��׼��
tmp = input('Accept(enter) or not(any number): ');
if isempty(tmp) % ͬ��ROI���ɼ�������
    for i = 1:size(fileList,1)
        sgnl = nmlAndSave1Mat(fileList(i).name,caliParam,plotOrNot);
        disp(['Processed:',fileList(i).name]);
    end
    disp('Success: task done');
else % ��ͬ��ROI������������
    disp('Warning: task terminate because of user veto ROI');
    return;
end
