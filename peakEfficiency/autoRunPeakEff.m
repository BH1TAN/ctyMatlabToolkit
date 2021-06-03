%% ģ��٤��̽�����Բ�ͬ��������٤�����ߵ���Ч�ʼ���Ч��

% ʹ�÷�����
% 1. �޸�tplt.tplt�е�Դ̽���μ�����
% 2. �޸�autoRunPeakEff��energyList��nps��tpltFileName
% 3. ֱ������autoRunPeakEff���ɣ��Զ�֧��linux��pc��

close all;clear;
energyList = (0.1:0.1:12)'; % MeV
nps = 1e5;
tpltFileName = 'tplt.tplt';
delete('*.i');delete('*.o');delete('*.r');
effCurve = zeros(size(energyList,1),5);
% ������MeV) ��Ч�� ��Ч�ʾ������ ��Ч�� ��Ч�����
effCurve(:,1)=energyList;

for i = 1:size(energyList,1)
    disp('---------------------------------------------');
    disp(['Current: ',num2str(energyList(i,1)),'MeV (',num2str(i), ...
        '/',num2str(size(energyList,1)),')']);
    workName = [num2str(i),'.i'];
    geninput(tpltFileName,workName,energyList(i,1),nps);
    disp(['MCNP start: ',datestr(now)]);
    if isunix
        [~,~]=system(['mpirun.lsf mcnp5.mpi.impi_intel i=',num2str(i), ...
            '.i o=',num2str(i),'.o r=',num2str(i),'.r p=',num2str(i),'.p']);
    else
        [~,~]=system(['mcnp5 i=',num2str(i),'.i o=',num2str(i),'.o r=', ...
            num2str(i),'.r p=',num2str(i),'.p']);
    end
    disp(['MCNP finish: ',datestr(now)]);
    [thisSpec,summary] = readOutput([num2str(i),'.o']);
    effCurve(i,2) = summary(1,1);
    effCurve(i,3) = summary(1,2);effCurve(i,3)=effCurve(i,3)*effCurve(i,2);
    fullEnergyCh = max(find(thisSpec(:,2)~=0));
    effCurve(i,4) = thisSpec(fullEnergyCh,2);
    effCurve(i,5) = thisSpec(fullEnergyCh,3);
    effCurve(i,5) = effCurve(i,5)*effCurve(i,4);
    delete([num2str(i),'.r']);
    save('effResult');
    disp(['Success: ',num2str(energyList(i,1)),'MeV (',num2str(i), ...
        '/',num2str(size(energyList,1)),')',datestr(now)]);
end
if ispc
    figure;
    plot(effCurve(:,1),effCurve(:,4),'-');
    hold on;
    xlabel('Energy(MeV)');ylabel('Peak Efficiency');
end

disp('==========Project done=============');

