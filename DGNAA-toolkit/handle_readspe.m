%% 获取同文件夹下的多个spe能谱信息
clear;close all;
dir1 = dir('A*.spe');
tZero= 0; % 首个能谱开始测量时刻(s)
t_start = cell(1,length(dir1)); % 时间字符串
t = zeros(1,length(dir1));
t_real = zeros(1,length(dir1));
t_live = zeros(1,length(dir1));
pErr = [];
tic;
for i = 1:length(dir1)
    disp(['Processing:',num2str(i),'/',num2str(length(dir1))]);toc;
    s = readspe(dir1(i).name);
    t_start{1,i} = s.startTime; % 时间字符串
    t_real(1,i) = s.realtime;
    t_live(1,i) = s.livetime;
    orgnSpec(:,i) = s.spec;
    if i>1 % 记录重复的能谱序号，最后统一删除
        if isequal(t_start{1,i},t_start{1,i-1})
            pErr = [pErr,i];
        end
    end
end
orgnSpec(:,pErr)=[];
t(:,pErr)=[];
t_real(:,pErr)=[];

for i = 1:length(t) 
    t(1,i) = etime(t_start{1,i},t_start{1,1})+tZero;% 计算测量时刻
end

save('data','orgnSpec','t','t_real','t_live','t_start','dir1');

h = figure;
yyaxis left
plot(t,sum(orgnSpec,1),'.-');
xlabel('Time(s)');
ylabel('Total count per file');
yyaxis right
plot(t,sum(orgnSpec,1)./t_live,'.-');
ylabel('Total count rate (cps)');
saveas(h,'decayCurve-totalcount.jpg');

