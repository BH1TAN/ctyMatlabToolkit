function sgnl = nmlAndSave1Mat(matFileName,plotOrNot,energyStep)
load(matFileName);

%% �̶�����
[orgnSpecsgnl,nmlSpecsgnl] = nml1spec(sum(sgnl,2),size(sgnl,2),energyStep,0);
if plotOrNot
    figure;
    semilogy(nmlSpecsgnl(:,1),nmlSpecsgnl(:,2),'.-');hold on;grid on;
    title(matFileName);
    xlabel('Energy(MeV)');
    ylabel(['Count rate(cps/',num2str(nmlSpecsgnl(2,1)-nmlSpecsgnl(1,1)),'MeV']);
end

%% ��׼��
sgnl = nmlMats(sgnl,orgnSpecsgnl(:,1),nmlSpecsgnl(:,1));

%% ����
save([matFileName(1:length(matFileName)-4),'-step',num2str(energyStep),'MeV-nml.mat',],'sgnl');

end


function nmlspecMat = nmlMats(orgnSpecMat,orgnEaxis,nmlEaxis)
% specMat: Ϊ���м���������
% orgnEaxis: specMat ���������ᣨ��λ��MeV��
% nmlEaxis: ��׼��Ŀ���������ᣨ��λ��MeV��
% nmlspecMat: ��׼�����м��������׾���

%% �任���� cps/ch -> cps/energyBin
specMat = orgnSpecMat*(nmlEaxis(5,1)-nmlEaxis(4,1))/ ...
    (orgnEaxis(5,1)-orgnEaxis(4,1)); % Unit of spec: cps/enrgybin

%% ��ֵ
nmlspecMat = zeros(size(nmlEaxis,1),size(specMat,2));
for i = 1:size(specMat,2)
    nmlspecMat(:,i) = spline(orgnEaxis,specMat(:,i),nmlEaxis);
end

%% ɾ����С��ֵ
nmlspecMat(find(nmlspecMat<(1/size(specMat,2)^2))) = 0;

%% ��ͼ�����������Ϣ
% colcol = 5;
% figure; 
% semilogy(orgnEaxis,specMat0(:,colcol),'o');hold on;grid on;
% semilogy(nmlEaxis,nmlspecMat(:,colcol),'.-');
% xlabel('Energy(MeV)');
% ylabel(['Count rate(cps/',num2str(nmlEaxis(2,1)-nmlEaxis(1,1)),'MeV']);
% title('Normalized 1s spectrum');

% disp(['ԭ1s���ܼ����ʣ�',num2str(sum(specMat(:,colcol))),'cps']);
% disp(['��׼��1s���ܼ����ʣ�',num2str(sum(nmlspecMat(:,colcol))),'cps'])
end
