function [aucList,handle] = aucList_v1(bkgd,smpl,whichPlace,sampleName,combinedCh,timeCombined,plotOrNot)
% ��ͼ������Ϊ�ϲ�����������ΪAUC���ߵ�����Ϊsmpl��Ԫ����
%
% INPUTS:
% bkgd: �޶�Ʒ���ף���ֵ����
% smpl����ͬԪ��Ϊ��ֵ��������һ������bkgd��ͬ��Ԫ������
% whichPlace: ���ĸ�λ�õ�ʶ��Ч��AUC���ߴأ�1*2��ֵ����
% sampleName: ͼ���ı��⣬����Ԫ������
% combinedCh��ͼ�к���Ϊ���ٵ���Ϊһ����������
% timeCombined: ÿ�������Ƕ೤ʱ��Ĳ���
% plotOrNot: �Ƿ�ͼ��1�ǣ�2��
%
% OUTPUTS:
% aucList: ÿһ��Ϊͬ���ϲ�������ʹ�ò�ͬλ�õ�fisher������AUC��ÿһ��Ϊʹ��
%          ͬһλ�õ�Fisher��������ͬ�ϲ�������AUC
% handle: auc���ߴ�ͼ��handle
%
lineWidth = 2;fontSize = 12;markerSize = 20;
aucList = zeros(length(combinedCh),length(sampleName));
handle = -1;
thisSample = smpl{whichPlace(1),whichPlace(2)};
for i = 1:size(smpl,1)*size(smpl,2)
    for j = 1:length(combinedCh)
        thisBKGD = resizemat_cut(bkgd,[floor(size(bkgd,1)/combinedCh(j)),floor(size(bkgd,2)/timeCombined)]);
        thisFisherSample = resizemat_cut(smpl{i},[floor(size(smpl{i},1)/combinedCh(j)),floor(size(smpl{i},2)/timeCombined)]);
        thisSMPL = resizemat_cut(thisSample,[floor(size(thisSample,1)/combinedCh(j)),floor(size(thisSample,2)/timeCombined)]);
        vec = myfisher(thisBKGD,thisFisherSample);
        [~,aucList(j,i)] = rocgauss(vec'*thisBKGD,vec'*thisSMPL,500);
    end
    disp([num2str(i),'/',num2str(size(smpl,1)*size(smpl,2))]);
end

if plotOrNot
    for i = 1:size(aucList,2)
        handle = plot(combinedCh,aucList(:,i),'.-','LineWidth',lineWidth,'MarkerSize',markerSize);hold on;
    end
    xlabel('Count of combined channels(#)');
    ylabel('AUC');
    ylim([0,1]);
    grid on;
    set(gca,'FontSize',fontSize);
    legend(sampleName,'Location','southeast');
    hold off;
end

end % of the function