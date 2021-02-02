function [sgnl,eAxisOld,eAxisNew] = nmlAndSave1Mat(sgnl,caliParam,plotOrNot)
% ��׼��matFileNameָʾ��.mat�ļ���sgnl���׾���
% ���������޷��������������з�����ʱ��ʹ�ñ�����
%
% Inputs��
% sgnl: ����׼���ľ���ÿ��Ϊһ������������
% plotOrNot: �Ƿ�ͼ
% energyStep:����bin�Ŀ�ȣ�MeV��
% caliParam.E(1)~(n)������ϵĶ������
% caliParam.Ewin(i,1)~(i,2)��i���ܷ����ڵĴ�������
% caliParam.EStep ��������(MeV)
% caliParam.maxE �������(MeV)
%
% Outputs��
% sgnl�� ��׼�������ף�������matFileName��һ�£������׽��������µ�mat�ļ���
% eAxisOld: ��׼����������
% eAxisNew: ��׼��ǰ������
%

%% �̶�
[orgnSpecsgnl,nmlSpecsgnl] = ...
    nml1spec_v4(sum(sgnl,2),caliParam,plotOrNot);
eAxisOld = orgnSpecsgnl(:,1);
eAxisNew = nmlSpecsgnl(:,1);
%% �任����
sgnl = nmlmat(sgnl,eAxisOld,eAxisNew,caliParam.tPerFile);

end


function nmldMat = nmlmat(orgnSpecMat,orgnEaxis,nmlEaxis,tCol)
% specMat: Ϊ���м���������
% orgnEaxis: specMat ���������ᣨ��λ��MeV��
% nmlEaxis: ��׼��Ŀ���������ᣨ��λ��MeV��
% nmlspecMat: ��׼�����м��������׾���
% tCol: ÿ�еĲ���ʱ������λ��s��

%% �任���� cps/ch -> cps/energyBin
specMat = orgnSpecMat*(nmlEaxis(5,1)-nmlEaxis(4,1))/ ...
    (orgnEaxis(5,1)-orgnEaxis(4,1)); % Unit of spec: cps/enrgybin

%% ��ֵ
nmldMat = zeros(size(nmlEaxis,1),size(specMat,2));
for i = 1:size(specMat,2)
    nmldMat(:,i) = spline(orgnEaxis,specMat(:,i),nmlEaxis);
end

%% ɾ����С��ֵ
nmldMat(find(nmldMat<(1/(size(specMat,2)*tCol)^2))) = 0;

end