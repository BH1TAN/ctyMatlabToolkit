function nmlspecMat = nmlSpecs(specMat,orgnEaxis,nmlEaxis)
% specMat: ����Ϊ����������
% orgnEaxis: specMat ���������ᣨ��λ��MeV��
% nmlEaxis: ��׼��Ŀ���������ᣨ��λ��MeV��
% nmlspecMat: ��׼�����м��������׾���

% �任���� cps/ch -> cps/energyBin
specMat0 = specMat*(nmlEaxis(5,1)-nmlEaxis(4,1))/ ...
    (orgnEaxis(5,1)-orgnEaxis(4,1)); % Unit of spec: cps/enrgybin

% ��ֵ
nmlspecMat = zeros(size(nmlEaxis,1),size(specMat0,2));
for i = 1:size(specMat0,2)
    nmlspecMat(:,i) = spline(orgnEaxis,specMat0(:,i),nmlEaxis);
end

% ɾ����С��ֵ
nmlspecMat(find(nmlspecMat<(1/size(specMat0,2)^2))) = 0;

% ��ͼ
colcol = 5;
% figure; 
% semilogy(orgnEaxis,specMat0(:,colcol),'o');hold on;grid on;
% semilogy(nmlEaxis,nmlspecMat(:,colcol),'.-');
% xlabel('Energy(MeV)');
% ylabel(['Count rate(cps/',num2str(nmlEaxis(2,1)-nmlEaxis(1,1)),'MeV']);
% title('Normalized 1s spectrum');

% disp(['ԭ1s���ܼ����ʣ�',num2str(sum(specMat(:,colcol))),'cps']);
% disp(['��׼��1s���ܼ����ʣ�',num2str(sum(nmlspecMat(:,colcol))),'cps'])
end
