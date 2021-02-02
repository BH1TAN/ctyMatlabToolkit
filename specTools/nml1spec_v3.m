function [orgnSpec,nmldSpec] = ...
    nml1spec_v3(nameOrSpec,measureTime,energyStep,plotOrNot, ...
    PeakE1,PeakRange1,PeakE2,PeakRange2)
% ��׼���������ף���511keV��2223keV�̶����ף�ͳһ����
% nameOrSpec: ������ֵ�������ף���spe��ʽ�����ļ�������λ������/����
% measureTime: ����ʱ������λ��s��
% originalSpec: ��nameOrSpecΪ�ļ�������Ϊ��ȡ�ĵ������ף���Ϊ������Ϊ�����
% normalizedSpec: ˫�����ף���һ��MeV�������ڶ��м�����
% REFERENCE: C-12 4.945;
% [orgnSpec,nmldSpec]=nml1spec_v2(nameOrSpec,600,0.01,1,0.478,[65,79],2.223,[300,359])

maxEnergyRange = 12; % MeV
energyAxis = (energyStep:energyStep:maxEnergyRange)';
%% ��������
if ischar(nameOrSpec) % ���ļ�
    spec = readspe(nameOrSpec);
else %�����׾���
    spec = sum(nameOrSpec,2);
end

%% ��ԭʼ����ͼ
if plotOrNot
    h=figure;subplot(221);
    jFrame = get(h,'JavaFrame');
    set(jFrame,'Maximized',1);
    semilogy(spec,'.-');xlabel('Channel');ylabel('Count rate(count/ch)');grid on;
end

%% Ѱ��(ʹ�ü�����ͼ)
if plotOrNot
    subplot(223);
end
[~,~,~,~,~,peak_1,~] = fitPeak((PeakRange1(1):PeakRange1(2))',spec(PeakRange1(1):PeakRange1(2))/measureTime,plotOrNot);
if plotOrNot
    subplot(224);
end
[~,~,~,~,~,peak_2,~] = fitPeak((PeakRange2(1):PeakRange2(2))',spec(PeakRange2(1):PeakRange2(2))/measureTime,plotOrNot);
%% �̶�
originalEScale = (PeakE2-PeakE1)*((1:size(spec,1))'-peak_1)/(peak_2-peak_1)+PeakE1;
orgnSpec = spec/measureTime; % Unit of spec: cps/ch
orgnSpec = orgnSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
orgnSpec = [originalEScale,orgnSpec];

%% ��ֵ
nmldSpec = spline(orgnSpec(:,1),orgnSpec(:,2),energyAxis);
nmldSpec(find(nmldSpec<1/measureTime^2))=0; % ������ʱ�����޼�����Ӧ�ļ�����Ϊ1/measureTime^2
nmldSpec = [energyAxis,nmldSpec];
if plotOrNot
    subplot(222);
    semilogy(orgnSpec(:,1),orgnSpec(:,2),'o');hold on;grid on;
    semilogy(nmldSpec(:,1),nmldSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(energyStep),'MeV)']);
    legend('Original','Normalized');
    xlim([0,maxEnergyRange]);
    pause(0.5);
end

end % of function
