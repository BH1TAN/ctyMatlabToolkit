function newSpecSeq = deleteoutlier(specSeq,stableTime,ROI,outlierThresh,plotOrNot)
% ɾ���������е���Ⱥ��
% specSeq:��׼�����������У�ÿһ��Ϊһ��׼������
% stableTime���ӵڼ������׿�ʼ�������ȶ�
% ROI���ṹ�壬ROIÿ���ֶδ洢ROI����
% outlierThresh������������׼��������Ⱥ��
% plotOrNot:�Ƿ�ͼ
% delCh: ÿһ��Ϊɾ����������ţ����ظ���ʹ��ǰ��unique(delCh)
% delSeg: ÿ����Ϊ��ͬ��ROIɾ�������ұ�����˵�

ROInames = fieldnames(ROI);
nROI = length(ROInames);
seq = zeros(nROI+1,size(specSeq,2));
for i = 1:nROI
    thisRange = getfield(ROI,ROInames{i});
    seq(i,:) = sum(specSeq(thisRange(1):thisRange(2),:),1);% �������ȶ���ĵ�
end
seq(i+1,:) = sum(specSeq,1); % ȫ���׼�����

delSeg = zeros(size(seq,1),1); % seqSeg���ָ������ұ�����Ϊ��������Ⱥ��
delCh = [];
for i = 1:size(seq,1)
    thisSeq = seq(i,:);% �������⣺ɾ����Ⱥ��Ӧ������Σ������޸�ʾ��ͼ����
    delCh = [delCh,find(thisSeq<mean(thisSeq(stableTime:end))-outlierThresh*std(thisSeq(stableTime:end),0))];
    delCh = [delCh,find(thisSeq>mean(thisSeq(stableTime:end))+outlierThresh*std(thisSeq(stableTime:end),0))];
    delCh(find(delCh<stableTime)) = [];
    delSeg(i,1) = size(delCh,2);
end

% չʾ��Ʒ��ɾ���ĵ�
if stableTime~=1
    delCh = [delCh,1:stableTime-1];
end
delSeg = [delSeg;size(delCh,2)];
newSpecSeq=specSeq;
newSpecSeq(:,unique(delCh)) = [];

% ʹ��specSeq,delCh,delSeg,ROI��ͼ
ROInames = [ROInames;'total'];
if plotOrNot
    for i = 1:nROI+1 
        figure;
        plot(1:size(specSeq,2),seq(i,:),'.-');hold on;
        % �����б�ɾ���ĵ�
        unique_delCh = unique(delCh);
        for j = 1:length(unique_delCh) 
            plot([unique_delCh(j),unique_delCh(j)],[0,seq(i,unique_delCh(j))],'m-');
        end
        % ����ROI��ɾ���ĵ�
        if i==1
            this_delCh = delCh(1:delSeg(i));
        else
            this_delCh = delCh(delSeg(i-1)+1:delSeg(i));
        end
        for j = 1:size(this_delCh,2)
            plot([this_delCh(j),this_delCh(j)],[0,seq(i,this_delCh(j))],'r-');
        end
        title({[ROInames{i},' sum out of ',num2str(outlierThresh),'\sigma']; ...
            ['Deleted ',num2str(length(unique_delCh)), ...
            ' (pink+red) in total. Here: ',num2str(length(this_delCh)),' (red)']; ...
            ['Average=',num2str(mean(seq(i,stableTime:end))), ...
            ' Std=',num2str(std(seq(i,stableTime:end),0))]});
        ymin = min(seq(i,:));ymax = max(seq(i,:));
        ylim([max([0,1.5*ymin-0.5*ymax]),1.5*ymax-0.5*ymin]);
        
        %% �������ʷֲ�ͼ
        thisOldSeq = seq(i,:);
        thisNewSeq = thisOldSeq;
        thisNewSeq(unique_delCh) = [];
        figure;
        h1=histogram(thisOldSeq);hold on;
        h2=histogram(thisNewSeq);
        h1.Normalization = 'probability';
        h2.Normalization = 'probability';
        h1.NumBins = 50;
        h2.BinEdges = h1.BinEdges;
        title(['Count rate distribution of specSeq of ',ROInames{i}]);
        xlabel('Count rate(cps)')
        % ylabel('Frequency (/',num2str(h1.BinWidth),'cps)');
        ylabel(['Probability (/',num2str(h1.BinWidth),'cps)']);
        legend('all','select');
    end
end
% 
% %% �������ʷֲ�ͼ
% figure;
% [y,x]=hist(sum(specSeq,1),0:1e2:5e4);
% plot(x,y,'r.-');hold on;
% [y,x]=hist(sum(newSpecSeq,1),0:1e2:5e4);
% plot(x,y,'b.-');
% title('Count rate distribution of specSeq full spectra');
% xlabel('Count rate(cps)')
% ylabel('Frequency (/100cps)');
% legend('all','select');
% specSeq(:,delCh) = [];clearvars specSeq0;


end

