%% ģ��٤��̽�����Բ�ͬ��������٤�����ߵ���Ч�ʼ���Ч��

% ʹ�÷�����
% 1. �޸�tplt.tplt�е�Դ̽���μ�����
% 2. �޸�autoRunPeakEff��paramList��nps��tpltFileName
% 3. ֱ������autoRunPeakEff���ɣ��Զ�֧��linux��pc��

% effCurve: ������MeV) ��Ч�� ��Ч�ʾ������ ��Ч�� ��Ч�ʾ������

close all;clear;
% delete('*.i');delete('*.o');delete('*.r');
tpltFileName = 'tplt.tplt';
onlyWrite = 0; % ֻ���������ļ���������MCNP
onlyRead = 0; % ֻ��ȡoutput�ļ���������MCNP

radius = [1:5,10,15,20,30,40]';
height = [1:5,5.5,6,10,15,20,30,40]';
density = [0.2:0.1:3]';
energy = [0.2,0.41,0.6:0.2:6]'; % MeV

radius = 1.1111;
height = 2.222;
density = 3.333;
energy = 4.444; % MeV

%% ����paramList
lengthList = length(radius)*length(height)*length(density)*length(energy);
paramList = zeros(lengthList,4);
j=1;
for i1 = 1:length(radius)
    for i2 = 1:length(height)
        for i3 = 1:length(density)
            for i4 = 1:length(energy)
                paramList(j,:)= [radius(i1),height(i2),density(i3),energy(i4)];
                j = j+1;
            end
        end
    end
end

%% ����������effCurve�ڴ�ռ�
% ������MeV) ��Ч�� ��Ч�ʾ������ ��Ч�� ��Ч�����
effCurve = zeros(size(paramList,1),5);

%% ���������ļ�
for i = 1:size(paramList,1)
    geninput(tpltFileName,[num2str(i),'.i'],paramList(i,:));
end
if onlyWrite
    return;
end

%% ���ļ�����
for i = 1:size(paramList,1)
    disp('---------------------------------------------');
    disp(['Processing: ',num2str(i),'/',num2str(size(paramList,1)), ...
        ' (',num2str(100*i/size(paramList,1)),'%)']);
    if ~onlyRead
        disp(['MCNP start: ',datestr(now)]);
        if isunix
            [~,~]=system(['mpirun.lsf mcnp5.mpi.impi_intel i=',num2str(i), ...
                '.i o=',num2str(i),'.o r=',num2str(i),'.r p=',num2str(i),'.p']);
        else
            [~,~]=system(['mcnp5 i=',num2str(i),'.i o=',num2str(i),'.o r=', ...
                num2str(i),'.r p=',num2str(i),'.p']);
        end
        disp(['MCNP finish: ',datestr(now)]);
    end
    [thisSpec,summary] = readOutput([num2str(i),'.o']);
    effCurve(i,2) = summary(1,1);
    effCurve(i,3) = summary(1,2);effCurve(i,3)=effCurve(i,3)*effCurve(i,2);
    % fullEnergyCh = max(find(thisSpec(:,2)~=0)); % ȫ������λ��
    [~,fullEnergyCh] = min(abs(thisSpec(:,1)-paramList(i,1)));
    effCurve(i,4) = thisSpec(fullEnergyCh,2);
    effCurve(i,5) = thisSpec(fullEnergyCh,3);
    effCurve(i,5) = effCurve(i,5)*effCurve(i,4);
    if ~onlyRead
        delete([num2str(i),'.r']);
    end
    save('effResult');
    disp(['Success: ',num2str(paramList(i,1)),'MeV (',num2str(i), ...
        '/',num2str(size(paramList,1)),')',datestr(now)]);
end
if ispc
    figure;
    errorbar(effCurve(:,1),effCurve(:,4),effCurve(:,5),'-');
    hold on;
    xlabel('Energy(MeV)');ylabel('Peak Efficiency');
end

disp('==========Project done=============');

