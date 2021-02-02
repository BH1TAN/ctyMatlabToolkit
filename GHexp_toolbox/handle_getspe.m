%% ��ȡͬ�ļ����µĶ��spe������Ϣ

%clear;close all;
dir1 = dir('fake*.spe');
tZero= 0; % �׸����׿�ʼ����ʱ��(s)
t_start = cell(1,length(dir1)); % ʱ���ַ���
t = zeros(1,length(dir1));
t_realtime = zeros(1,length(dir1));
pErr = [];
tic;
for i = 1:length(dir1)
    disp(['Processing:',num2str(i),'/',num2str(length(dir1))]);toc;
    s = readspe(dir1(i).name);
    t_start{1,i} = s.startTime; % ʱ���ַ���
    t_realtime(1,i) = s.realtime;
    orgnSpec(:,i) = s.spec;
    if i>1 % �������ظ�������
        if isequal(t_start{1,i},t_start{1,i-1})
            pErr = [pErr,i];
        end
    end
end
orgnSpec(:,pErr)=[];
t(:,pErr)=[];
t_realtime(:,pErr)=[];

for i = 1:length(t) 
    t(1,i) = etime(t_start{1,i},t_start{1,1})+tZero;% �������ʱ��
    spec(:,i)=orgnSpec(:,i)/t_realtime(1,i);
end

figure;
plot(t,sum(spec,1),'.-');
xlabel('Time(s)');
ylabel('Total count rate(cps/ch)');

save('data','orgnSpec','t','t_realtime','spec');
