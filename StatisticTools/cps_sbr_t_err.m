%% 信号计数率，信本比，测量时长，统计涨落 相互关系
% 四幅图，横轴计数率，纵轴精度，图例测量时长，图标题SBR
% S = T-B = s*t
% B = s/sbr*t
% delta(S) = sqrt(T+B) = sqrt(2*B+S)
% err = sqrt(2*B+S)/S = sqrt((2+sbr)/(s*t*sbr))
% s = (2+sbr)/(t*sbr*err^2)

clear;close all;
err = [0.001,0.005,0.01,0.1]';
sbr = [0.1,1,10,100]';
content = {'SBR=0.1','SBR=1','SBR=10','SBR=100'};
t = [0.1:0.1:600]'; % unit: s

for i = 1:length(err)
    s=[];
    for j = 1:length(sbr)
        s(:,j) = (2+sbr(j))./(t*sbr(j)*err(i)^2);
    end
    ss{i}=s;
    subplot(2,2,i)
    semilogy(t,s,'-');grid on;
    xlabel('Measurement time(s)','fontName','Times New Roman');
    ylabel('Count rate(cps)','fontName','Times New Roman');
    title(['Precision=',num2str(100*err(i)),'%'],'fontName','Times New Roman');
    legend(content,'Location','best','fontName','Times New Roman');
    disp(num2str(i));
end

