function [originalSpec,normalizedSpec] = nml1spec(nameOrSpec,measureTime,energyStep,plotOrNot)
% ��׼���������ף���511keV��2223keV�̶����ף�ͳһ����
% nameOrSpec: ������ֵ�������ף���spe��ʽ�����ļ�������λ������/����
% measureTime: ����ʱ������λ��s��
% originalSpec: ��nameOrSpecΪ�ļ�������Ϊ��ȡ�ĵ��м������ף���Ϊ������Ϊ�����
% normalizedSpec: ˫�����ף���һ��MeV�������ڶ��м�����

maxEnergyRange = 12; % MeV
energyAxis = (energyStep:energyStep:maxEnergyRange)';
PEAKRANGE_511 =  [27,50]; %[70,120]; 
PEAKRANGE_2223 = [137,174]; %[330,400]; 
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
[~,~,~,~,~,peak_511,~] = fitPeak((PEAKRANGE_511(1):PEAKRANGE_511(2))',spec(PEAKRANGE_511(1):PEAKRANGE_511(2))/measureTime,plotOrNot);
[~,~,~,~,~,peak_H2223,~] = fitPeak((PEAKRANGE_2223(1):PEAKRANGE_2223(2))',spec(PEAKRANGE_2223(1):PEAKRANGE_2223(2))/measureTime,plotOrNot);

%% �̶�
originalEScale = (2.223-0.511)*((1:size(spec,1))'-peak_511)/(peak_H2223-peak_511)+0.511;
originalSpec = spec/measureTime; % Unit of spec: cps/ch
originalSpec = originalSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
originalSpec = [originalEScale,originalSpec];

%% ��ֵ
normalizedSpec = spline(originalSpec(:,1),originalSpec(:,2),energyAxis);
normalizedSpec(find(normalizedSpec<1/measureTime^2))=0; % ������ʱ�����޼�����Ӧ�ļ�����Ϊ1/measureTime^2
normalizedSpec = [energyAxis,normalizedSpec];
if plotOrNot
    figure;
    semilogy(originalSpec(:,1),originalSpec(:,2),'o');hold on;grid on;
    semilogy(normalizedSpec(:,1),normalizedSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(energyStep),'MeV)']);
    legend('Original','Normalized');
end

% disp(['ԭ���ܼ����ʣ�',num2str(sum(spec)/measureTime),'cps']);
% disp(['��׼�����ܼ�����:',num2str(sum(normalizedSpec(:,2))),'cps']);

end % of function nml1spec
