function [orgnSpec,t,t_real,t_live] = readspeinfolder(foldername)
% 读取ortec循环存储的多个spe能谱并作图、保存
%
dir1 = dir([foldername,'\*.spe']);
t_start = cell(1,length(dir1)); % 时间字符串
t = zeros(1,length(dir1));
t_real = zeros(1,length(dir1));
t_live = zeros(1,length(dir1));
pErr = [];
tic;
for i = 1:length(dir1)
    disp(['Reading spe:',num2str(i),'/',num2str(length(dir1))]);
    disp(['Reading will finish in ',num2str(toc/i*(length(dir1)-i)),' second']);
    s = readspe([foldername,'\',dir1(i).name]);
    t_start{1,i} = s.startTime; % 时间字符串
    t_real(1,i) = s.realtime;
    t_live(1,i) = s.livetime;
    orgnSpec(:,i) = s.spec;
    if i>1 % 储存重复的能谱
        if isequal(t_start{1,i},t_start{1,i-1})
            pErr = [pErr,i];
        end
    end
end
if ~isempty(pErr)
    orgnSpec(:,pErr)=[];
    t(:,pErr)=[];
    t_real(:,pErr)=[];
end

for i = 1:length(t)
    t(1,i) = etime(t_start{1,i},t_start{1,1});% 计算测量起始时刻
end

figure;
subplot(211);
plot(t,sum(orgnSpec,1),'.-');grid on;
xlabel('Time(s)');
ylabel('Total count per file');
subplot(212);
plot(sum(orgnSpec,1),'.-');grid on;
xlabel('File No.');
ylabel('Total count per file');

save([foldername,'.mat'],'orgnSpec','t','t_real','t_live');

end

