%% 信号计数，信本比，统计涨落 相互关系
% 四幅图，横轴测量时长，纵轴计数率，图例SBR，图标题精度
% S = T-B 
% B = S/sbr
% delta(S) = sqrt(T+B) = sqrt(2*B+S)
% err = sqrt(2*B+S)/S = sqrt((2+sbr)/(S*sbr))

clear;close all;
s = 10.^(0:0.1:7)';
sbr = [0.01,0.1,1,10,100]';
content = {'\it{r} = 0.01','\it{r} = 0.1','\it{r} = 1','\it{r} = 10','\it{r} = 100'};

for i = 1:length(sbr)
    err(:,i) = 100 * sqrt((2+sbr(i))./(sbr(i)*s));
end

    loglog(s,err,'-','LineWidth',1.5);grid on;
    %ylim([0,20]);
    ylim([10^-1,10^2]);
    xlim([min(s),max(s)]);
    ax = gca;
    ax.YAxis.Exponent = 0;
    xlabel('Net count \it{C}','Interpreter','latex','fontName','Times New Roman');
    ylabel('Precision $\frac{\Delta\it{C}}{\it{C}}$ (\%)','Interpreter','latex','fontName','Times New Roman');
    legend(content,'Location','best','fontName','Times New Roman','Interpreter','latex');