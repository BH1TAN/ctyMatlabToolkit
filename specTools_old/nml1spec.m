function [orgnSpec,nmldSpec] = nml1spec(nameOrSpec,measureTime,energyStep,plotOrNot)
% ��׼���������ף���511keV��2223keV�̶����ף�ͳһ����
% nameOrSpec: ������ֵ�������ף���spe��ʽ�����ļ�������λ������/����
% measureTime: ����ʱ������λ��s��
% originalSpec: ��nameOrSpecΪ�ļ�������Ϊ��ȡ�ĵ������ף���Ϊ������Ϊ�����
% normalizedSpec: ˫�����ף���һ��MeV�������ڶ��м�����
% REFERENCE: C-12 4.945;
maxEnergyRange = 12; % MeV
energyAxis = (energyStep:energyStep:maxEnergyRange)';
PEAKENERGY_1 = 4.945;
PEAKENERGY_2 = 2.223;
PEAKRANGE_1 = [598,647];
PEAKRANGE_2 = [254,307];

%% ��������
if ischar(nameOrSpec) % �Ǿ���
    specStartStr = '$DATA:';
    fid = fopen(nameOrSpec,'r');
    for i =1:2100
        dataRow = fgetl(fid);
        if strncmp(dataRow,specStartStr,6)
            specStartRow = i;
            break;
        end
    end
    fclose(fid);
    fileData = importdata(nameOrSpec,'',specStartRow+1);
    spec = fileData.data;% �޿̶ȵ������ף����������count/ch
else %�����׾���
    spec = sum(nameOrSpec,2);
end

%% ��ԭʼ����ͼ
if plotOrNot
figure;
semilogy(spec,'o-');xlabel('Channel');ylabel('Count rate(count/ch)');grid on;
end

%% Ѱ��(ʹ�ü�����ͼ)
[~,~,~,~,~,peak_511,~] = fitPeak((PEAKRANGE_1(1):PEAKRANGE_1(2))',spec(PEAKRANGE_1(1):PEAKRANGE_1(2))/measureTime,plotOrNot);
[~,~,~,~,~,peak_H2223,~] = fitPeak((PEAKRANGE_2(1):PEAKRANGE_2(2))',spec(PEAKRANGE_2(1):PEAKRANGE_2(2))/measureTime,plotOrNot);

%% �̶�
originalEScale = (PEAKENERGY_2-PEAKENERGY_1)*((1:size(spec,1))'-peak_511)/(peak_H2223-peak_511)+PEAKENERGY_1;
orgnSpec = spec/measureTime; % Unit of spec: cps/ch
orgnSpec = orgnSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
orgnSpec = [originalEScale,orgnSpec];

%% ��ֵ
nmldSpec = spline(orgnSpec(:,1),orgnSpec(:,2),energyAxis);
nmldSpec(find(nmldSpec<1/measureTime^2))=0; % ������ʱ�����޼�����Ӧ�ļ�����Ϊ1/measureTime^2
nmldSpec = [energyAxis,nmldSpec];
if plotOrNot
    figure;
    semilogy(orgnSpec(:,1),orgnSpec(:,2),'o');hold on;grid on;
    semilogy(nmldSpec(:,1),nmldSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(energyStep),'MeV)']);
    legend('Original','Normalized');
end

% disp(['ԭ���ܼ����ʣ�',num2str(sum(spec)/measureTime),'cps']);
% disp(['��׼�����ܼ�����:',num2str(sum(normalizedSpec(:,2))),'cps']);

end % of function
