%% ��ȡ�ߴ���ѭ�������Ļ�������
% ʹ�ú����ֶ��γ�pks.mat��Ȼ�����
% handle_nmlHPGe �������� 
% handle_halflife����ÿ����İ�˥�� ��
% handle_acticity������� ��

clear;close all;
dir1 = dir('AUTO*.spe');
tZero= 0; % �׸����׿�ʼ����ʱ��(s)
t_start = cell(1,length(dir1)); % ʱ���ַ���
t = zeros(1,length(dir1));
t_realtime = zeros(1,length(dir1));


for i = 1:length(dir1)
    disp(['Processing:',num2str(i),'/',num2str(length(dir1))]);
    s = readspe(dir1(i).name);
    t_start{1,i} = s.startTime; % ʱ���ַ���
    t_realtime(1,i) = s.realtime;
    orgnSpec(:,i) = s.spec;
end
for i = 1:length(dir1) 
    t(1,i) = etime(t_start{1,i},t_start{1,1})+tZero;% �������ʱ��
    sgnl(:,i)=orgnSpec(:,i)/t_realtime(1,i);
end

figure;
plot(t,sum(sgnl,1),'.-');
xlabel('Time(s)');
ylabel('Total count rate(cps/ch)');

save('data','orgnSpec','t','t_realtime','sgnl','t_start');