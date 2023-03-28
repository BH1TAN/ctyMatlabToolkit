%% ������ͬ��İ�˥��
% �����жϺ���ʹ�ã���������������û����ó��ڲ�������handle_activity��������
%    �������ײ���ʱ�����ɵ���������
% ʹ��ǰ��Ҫ�γɵ���pks����������pks.mat

clear;close all;
load('pksUnknown.mat');
fileName = 'yellow2-spec-300s';
load([fileName,'.mat']);
%pks(:,2)=eAxis(pks(:,1),1);
pks(:,2) = 0;
method_getnet = 3; % ����徻�����ķ��������getnet.m
%% ����Ʒ�ĵ�һ���������
f=figure;
plot(sum(orgnSpec,1),'.-');xlabel('No.');ylabel('Total count');
title('Please enter the first activation spec No.');
nStart = input('Enter the first spec No. to be fit: ');
close(f);

%% ɾ��ʼ�ı�����
sp = orgnSpec(:,nStart:end); % ������
tt = t(nStart:end);
tt = tt-tt(1);
seq = zeros(size(pks,1),size(sp,2));
seq_gross = zeros(size(pks,1),size(sp,2));
%% ȡ����������
for i = 1:size(sp,2)
    thisSpec = sp(:,i);
    for j = 1:size(pks,1)
        disp(['Processing spec#:',num2str(i),'/', ...
            num2str(size(sp,2)),' peak:',num2str(j),'/', ...
            num2str(size(pks,1))]);
        [~,thispeak] = max(thisSpec(pks(j,1)-10:pks(j,1)+10)); % ����10����Ѱ��
        thispeak = thispeak + pks(j,1) - 11;
        [aaa,bbb] = getnet2(thisSpec,[pksrange(j,1):pksrange(j,2)]);
        seq(j,i) = aaa/t_livetime(i)*t_realtime(i);
        seq_gross(j,i) = bbb/t_livetime(i)*t_realtime(i);
        %seq(j,i) = getnet(thisSpec,thispeak,method_getnet)/t_livetime(i)*t_realtime(i);
    end
end

%% ���˥������
% seq,pks(��һ�е�ַ�ڶ�������),tt,
mkdir(['decayCurve-',fileName]);
result = zeros(size(1,1),5);
for i = 1:size(pks,1) % ���
    thisSeq = seq(i,:);
    syms x;
    f=fittype('a+b*exp(-u*x)','independent','x','coefficients',{'a','b','u'});
    options = fitoptions('Method','NonlinearLeastSquares');
    options.StartPoint = [thisSeq(end),thisSeq(1),1e-4];
    options.Lower = [0,0,0];
    [cfun,gof] = fit(tt',thisSeq',f,options);
    f=figure;
    plot(tt',thisSeq','o');hold on;
    plot(tt',cfun(double(tt)),'-');
    title({['Peak#',num2str(i),' ch=',num2str(pks(i,1)),' Energy=',num2str(pks(i,2),'%.2f'),' keV']; ...
        ['T0.5=',num2str(log(2)/cfun.u,'%.2f'),' s',' R^2= ',num2str(gof.rsquare,'%.2f')];
        ['a=',num2str(cfun.a,'%.2f'),' b=',num2str(cfun.b,'%.2f')]});
    xlabel('Time(s)');ylabel('Count');
    saveas(f,['decayCurve-',fileName,'/ch',num2str(pks(i,1)),'.png']);
    result(i,1) = pks(i,1); % ��ַ
    result(i,2) = pks(i,2); % ����MeV
    result(i,3) = cfun.a; % ���׼�����
    result(i,4) = cfun.b-cfun.a; % t=0 ������
    if gof.rsquare>0
    result(i,5) = gof.rsquare; % ��Ϻû� Rsquare
    else
        result(i,5) = 0;
    end
    result(i,6) = log(2)/cfun.u; % ��˥��s
end
disp('According to experiences, rSquare > 0.7 is reasonable fit');
disp(['decay curve saved in folder: decayCurve',fileName]);
save(['decay2-',fileName],'result','pks','seq','tt','sp');

%% ���������׵ķ徻����
disp('Enter to close all figures and continue... ');pause();
close all;
area = zeros(size(pks,1),2); 
spec_meas = sum(orgnSpec,2)/sum(t_livetime)*sum(t_realtime);
for i = 1:size(pks,1) % ���
    disp(['Processing peak ',num2str(i),'/',num2str(size(pks,1))]);
    rr = pks(i,1)-65:pks(i,1)+65;% �������
    %figure;
    [area(i,1),~,~,~,~] = fitPeak(rr,spec_meas(rr),0);
    area(i,1)=area(i,1)/sum(t_livetime)*sum(t_realtime); % fitted peak net area
    area(i,2)=sum(spec_meas(rr))/sum(t_livetime)*sum(t_realtime); % gross peak area
end
save(['decay2-',fileName],'result','pks','seq','tt','sp','spec_meas','area');
disp('��result,area(:,1)���ݸ�����excel');
disp('result����Ϊ˥�������ϵĵ�ַ������(ȡ���ڱ���pks)�����׼�����(cps)����ʼ������(cps)��R2,��ϰ�˥��(s)');
disp('area��һ��Ϊmatlab��ϵĲ���ʱ����ڷ徻�������Ѿ�����ʱ��������');
