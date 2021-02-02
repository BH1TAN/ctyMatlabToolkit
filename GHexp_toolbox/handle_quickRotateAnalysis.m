clear;close all;
%% �Ա����޶�Ʒ�ڲ�ͬ�Ƕȵ�����
nameSymbol_b = 'SEP23-P00-R8';
nameSymbol_s = 'SEP23-P24-1kg-R10';
nR = 5;
nSpecPerR = 64;
n2 = 8; % �ϲ����ڽǶ�������һȦ���ٸ���
nCh = 12; % ���׺ϲ�Ϊ���ٵ���
plotOrNot = 1;

%% ���Ӽ�����У��
file_bg = ['CH0-',nameSymbol_b,'-step0.01MeV-nml.mat'];
file_bn = ['CH2-',nameSymbol_b,'.mat'];
load(file_bg);bg = sgnl(:,1:nR*nSpecPerR);
load(file_bn);bn = sum(sgnl(:,1:nR*nSpecPerR),1);

file_sg = ['CH0-',nameSymbol_s,'-step0.01MeV-nml.mat'];
file_sn = ['CH2-',nameSymbol_s,'.mat'];
load(file_sg);sg = sgnl(:,1:nR*nSpecPerR);
load(file_sn);sn = sum(sgnl(:,1:nR*nSpecPerR),1);

figure;
subplot(311);
plot((1:nR*nSpecPerR)',[sum(bn,1)',sum(sn,1)'],'.-');hold on;
xlabel('Spec No.');
ylabel('Count');
title('Not calibrated neutron sum count sequence');
legend({['bkgd,mean=',num2str(mean(sum(bn,1)),4), ...
    ' var=',num2str(var(sum(bn,1)),4)]; ...
    ['smpl,mean=',num2str(mean(sum(sn,1)),4), ...
    ' var=',num2str(var(sum(sn,1)),4)]},'Location','southeast');
subplot(312);
plot((1:nR*nSpecPerR)',[sum(bg,1)',sum(sg,1)'],'.-');hold on;
xlabel('Spec No.');
ylabel('Count');
title('Not calibrated gamma sum count sequence');
legend({['bkgd,mean=',num2str(mean(sum(bg,1)),6), ...
    ' var=',num2str(var(sum(bg,1)),6)]; ...
    ['smpl,mean=',num2str(mean(sum(sg,1)),6), ...
    ' var=',num2str(var(sum(sg,1)),6)]},'Location','southeast');

for i = 1:nR*nSpecPerR % ����У��
    bg(:,i) = mean([bn,sn])*bg(:,i)./bn(i);
    sg(:,i) = mean([bn,sn])*sg(:,i)./sn(i);
end
subplot(313)
plot((1:nR*nSpecPerR)',[sum(bg,1)',sum(sg,1)'],'.-');hold on;
xlabel('Spec No.');
ylabel('Count');
title('Calibrated gamma sum count sequence');
legend({['bkgd,mean=',num2str(mean(sum(bg,1)),6), ...
    ' var=',num2str(var(sum(bg,1)),6)]; ...
    ['smpl,mean=',num2str(mean(sum(sg,1)),6), ...
    ' var=',num2str(var(sum(sg,1)),6)]},'Location','southeast');
hold off;

%% ��ת�Ӻ�
disp('Adding bkgd spec seq...');
[b,~]=rotateadd(bg,nR,nSpecPerR);
disp('Adding smpl spec seq...');
[s,~]=rotateadd(sg,nR,nSpecPerR);

%% �ϲ����ڽǶ�
s = resizemat(s,[size(s,1),n2])/nSpecPerR*n2;
b = resizemat(b,[size(b,1),n2])/nSpecPerR*n2;

win = zeros(0,size(s,1));
%win(1,1:end) = 1;
win(1,611-15:611+15)=1;
win(2,662-15:662+15)=1;
win(3,780-15:780+15)=1;
winLegend = {'6111';'6621';'7800'};

ang = 360/n2:360/n2:360;
seq_b = win*b;
seq_s = win*s;
for i = 1:size(seq_b,1)
figure;
plot(ang',[seq_b(i,:);seq_s(i,:)]','.-');hold on;
plot([0;360],[0;0],'k--');
xlabel('Rotate Angle(\circ)');xlim([0 360]);
ylabel('Count in E window in 1 s');
title(['Counts on different angle on ',winLegend{i},' keV']);
legend({'bkgd';'smpl'},'Location','southwest');
hold off;
end
figure;
seq = seq_s-seq_b;
plot(ang',seq','.-');hold on;
plot([0;360],[0;0],'k--');
xlabel('Rotate Angle(\circ)');xlim([0 360]);
ylabel('Delta count in E window in 1 s');
title('smpl-bkgd on different angle');
legend(winLegend);
hold off;

%% ֱ������1
s = resizemat(s,[nCh,size(s,2)]);
b = resizemat(b,[nCh,size(b,2)]);
figure;
plot((12/size(b,1):12/size(b,1):12)',b);
legend
figure;
plot((12/size(s,1):12/size(s,1):12)',s);
legend
%% ֱ������2
figure;
subplot(131)
imagesc(ang,12/size(b,1):12/size(b,1):12,b);colorbar;
xlabel('Rotate Angle(\circ)');
ylabel('Energy(MeV)');
subplot(132)
imagesc(ang,12/size(s,1):12/size(s,1):12,s);colorbar;
xlabel('Rotate Angle(\circ)');
ylabel('Energy(MeV)');
subplot(133)
tmp = s-b;
tmp(tmp<=0)=1e-11;
imagesc(ang,12/size(s,1):12/size(s,1):12,log(tmp)/log(10));colorbar;
caxis([-1 3]);
xlabel('Rotate Angle(\circ)');
ylabel('Energy(MeV)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [g_add,g_angle]=rotateadd(specMat,nR,nSpecPerR)
% ���ѱ�׼�������������У�ͬ�Ƕ����׼Ӻ�
% Inputs:
% specMat��ÿ��Ϊһ�����ף�����nR*nSpecPerR��
% nR: ��Ч����תȦ��
% nSpecPerR: ÿȦ�ж��ٸ�����
%
% Outputs��
% g_add: ÿһ��Ϊ�ض��Ƕȶ�Ӧ������
% g_angle: �Ƕ�
%
% Ref:
% 

% ͬ�Ƕ����׼Ӻ�
g_angle = (360/nSpecPerR:360/nSpecPerR:360);
angleList = mod((360/nSpecPerR:360/nSpecPerR:360/nSpecPerR*nSpecPerR*nR),360);

g_add = zeros(size(specMat,1),size(g_angle,2));
for i = 1:size(g_angle,2)
    g_add(:,i) = sum(specMat(:,find(angleList==g_angle(i))),2)/ nR;
end
end