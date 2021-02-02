%% �����������ʱʱ��ı仯
% ������ʹ��handle_coincurve�ű�Ѱ�Һ��ʵ���ʱʱ��
% ���ű���Ҳ�ɼ���coincurve���������2D�����ٶȽ���

clear;close all;
dataName = 'nacl';% Name of the list mode file
load([dataName,'.mat']); % ���� eventList
coin_time = 500; % unit: ns
timeDelay = (-1000:100:1000)'; % unit: ns
maxCh_a = 8192;
maxCh_b = maxCh_a;
chSelect = [3,4]; % ���Է��ϵĵ�ַ
size_smallspec = [256,256];
coinWinCh_a = [100,8192]; % �������ߵ�ROI
coinWinCh_b = [100,8192];
plotOrNot = 1;

% ���������Է��ϵ�����
data_a = eventList(find(eventList(:,2)==chSelect(1)),:);
data_b = eventList(find(eventList(:,2)==chSelect(2)),:);
eventList = [data_a;data_b];

% ��ά���ױ���Ϊ��Ƶ
spec2D_small = cell(length(timeDelay),1);
if plotOrNot
    v = VideoWriter([dataName,'.avi']);
    v.FrameRate = 4; % һ�뼸֡
    open(v);
end

% ����ʱ�����ά����
coinCurve = [timeDelay,zeros(length(timeDelay),1)];
for j = 1:length(timeDelay)
    seq = eventList;
    seq(find(seq(:,2)==chSelect(2)),1) = seq(find(seq(:,2)==chSelect(2)),1) - timeDelay(j); % Ch_b��ʱ
    seq = sortrows(seq);
    spec2D=zeros(maxCh_a,maxCh_b);
    disp(['Calculating 2D spec:',num2str(j),'/',num2str(length(timeDelay))]);
    for i = 1:size(seq,1)-1
        if seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)<seq(i+1,2)
            % ע��ch1�ĵ�ַΪ�кţ����2D���׵�����Ϊch1
            spec2D(seq(i,3),seq(i+1,3)) = spec2D(seq(i,3),seq(i+1,3))+1;
            continue;
        elseif seq(i+1,1)-seq(i,1)<=coin_time && seq(i,2)>seq(i+1,2)
            spec2D(seq(i+1,3),seq(i,3)) = spec2D(seq(i+1,3),seq(i,3))+1;
            continue;
        end
        if seq(i,2)==1
            spec2D(seq(i,3),1) = spec2D(seq(i,3),1)+1;
        elseif seq(i,2)==2
            spec2D(1,seq(i,3)) = spec2D(1,seq(i,3))+1;
        else
            error('Invalid channel');
        end
        %disp(num2str(i));
    end
    spec2D_small{j} = resizemat(spec2D,size_smallspec);
    coinCurve(i,2) = sum(sum(spec2D(coinWinCh_a(1):coinWinCh_a(2),coinWinCh_b(1):coinWinCh_b(2))));
    if plotOrNot
        figure;
        h=pcolor(size(spec2D)/size(spec2D_small{j}): ...
            size(spec2D)/size(spec2D_small{j}): ...
            size(spec2D),size(spec2D)/size(spec2D_small{j}): ...
            size(spec2D)/size(spec2D_small{j}): ...
            size(spec2D), ...
            spec2D_small{j});
        hc=colorbar;
        set(h,'edgecolor','none');
        hc.Title.String = 'Count';
        caxis([0,50]);
        %caxis([0,max(max(spec2D_small{j}(2:end,2:end)))]);
        xlabel(['Ch ',num2str(chSelect(2))]);
        ylabel(['Ch ',num2str(chSelect(1))]);
        title(['Time delay = ',num2str(timeDelay(j)),' ns']);
        disp(['Writing vedio:',num2str(j),'/',num2str(length(timeDelay))]);
        writeVideo(v,getframe(gcf));
    end
end
if plotOrNot
    close(v); % �ر���Ƶ
    figure;
    plot(coinCurve(:,1),coinCurve(:,2),'.-');
    xlabel('Time delay(ns)');
    ylabel('Coincidence count');
end
disp('Saving data...');
save([dataName,'-2DspecTime']);

