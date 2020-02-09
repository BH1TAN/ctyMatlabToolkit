function [originalSpec,normalizedSpec] = quicknml(nameOrSpec,measureTime,cali_table,energyStep,plotOrNot)
%

energyAxis = (energyStep:energyStep:12)';

% �����ļ�
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

% �̶�
if size(cali_table,2)==2
    ch_1 = cali_table(1,1);
    ch_2 = cali_table(2,1);
    energy_1 = cali_table(1,2);
    energy_2 = cali_table(2,2);
    originalEScale = (energy_2-energy_1)*((1:size(spec,1))'-ch_1)/(ch_2-ch_1)+energy_1; %������Ϊ����
elseif size(cali_table,2)==1
    originalEScale = cali_table;
end
originalSpec = spec/measureTime; % Unit of spec: cps/ch
originalSpec = originalSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
originalSpec = [originalEScale,originalSpec];

% ��ֵ
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


end