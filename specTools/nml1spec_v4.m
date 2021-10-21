function [orgnSpec,nmldSpec] = ...
    nml1spec_v4(nameOrSpec,caliParam,plotOrNot)
% ��˹��϶�λ��ֵ����׼��gamma����
% 
% INPUTS��
% nameOrSpec: ������ֵ�������ף���spe��ʽ�����ļ�������λ������/����
% caliParam.E(1,1)~(n,1)������ϵĶ������
% caliParam.Ewin(i,1)~(i,2)��i���ܷ����ڵĴ��µ�ַ���� 
% caliParam.EStep ��������(MeV)
% caliParam.maxE �������(MeV)
% caliParam.tPerFile ÿ���ļ��Ĳ���ʱ��s��������ɾ����С���ֵ
%
% OUTPUTS:
% orgnSpec: ��nameOrSpecΪ�ļ�������Ϊ��ȡ�ĵ������ף���Ϊ������Ϊ�����
% nmldSpec: ˫�����ף���һ��MeV�������ڶ��м�����
%
% REFERENCE: C-12 4.945;
%            caliParam.tPerFile = 300;
%            caliParam.E(1,1) = 1.46082;caliParam.Ewin(1,:) = [2116-10,2116+10];
%            caliParam.E(2,1) = 2.614511;caliParam.Ewin(2,:) = [3782-10,3782+10];
%            caliParam.EStep = 0.0001; % MeV
%            caliParam.maxE = 12;

energyAxis = (caliParam.EStep:caliParam.EStep:caliParam.maxE)';
%% ��������
if ischar(nameOrSpec) % ���ļ�
    spec = readspe(nameOrSpec);
else %�����׾���
    spec = nameOrSpec;
end

%% ��ԭʼ����ͼ
% if plotOrNot
%     semilogy(spec,'.-');xlabel('Channel');ylabel('Count rate(count/ch)');grid on;
% end

%% Ѱ��(ʹ�ü�����ͼ)
peakCh = zeros(length(caliParam.E),1);
if plotOrNot 
    h=figure;
    jFrame = get(h,'JavaFrame');
    set(jFrame,'Maximized',1);
end
for i = 1:length(caliParam.E)
    if plotOrNot
    subplot(ceil(length(caliParam.E)/2),2,i);
    end
    winwin = caliParam.Ewin(i,1):caliParam.Ewin(i,2);
    [~,~,~,peakCh(i),~] = fitPeak(winwin',sum(spec(winwin),2)/size(spec,2),plotOrNot);
end
pause(0.5);
%% �̶�
% originalEScale = (PeakE2-PeakE1)*((1:size(spec,1))'-peakCh)/(peak_2-peakCh)+PeakE1;
[p,~] = polyfit(peakCh,caliParam.E,1);
originalEScale = polyval(p,(1:size(spec,1))');
if plotOrNot
figure;
plot((1:size(spec,1))',originalEScale,'-');hold on;
plot(peakCh,caliParam.E,'r+');
xlabel('Channel');ylabel('Energy(MeV)');
end

%% �任���� cps/ch -> cps/energyBin
orgnSpec = spec/size(spec,2); % Unit of spec: cps/ch
orgnSpec = orgnSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
orgnSpec = [originalEScale,orgnSpec];

%% ��ֵ
nmldSpec = spline(orgnSpec(:,1),orgnSpec(:,2),energyAxis);
nmldSpec(find(nmldSpec<1/(size(spec,2)*caliParam.tPerFile)^2))=0; % ��������ʱ�����޼�����Ӧ�ļ�����Ϊ1/measureTime^2
nmldSpec = [energyAxis,nmldSpec];
if plotOrNot
    figure;
    semilogy(orgnSpec(:,1),orgnSpec(:,2),'o');hold on;grid on;
    semilogy(nmldSpec(:,1),nmldSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(caliParam.EStep),'MeV)']);
    legend('Original','Normalized');
    xlim([0,caliParam.maxE]);
end

end % of function
