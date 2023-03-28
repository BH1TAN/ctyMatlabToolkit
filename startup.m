%% 更优的画图参数

set(groot,'defaultLineLineWidth',1);
set(groot,'defaultAxesFontName','Times new roman');
set(groot,'defaultAxesFontSize',15);
set(groot,'defaultAxesLabelFontSizeMultiplier',1.1); %标签字体大小的缩放因子，默认为1.1
%set(groot,'defaultFigurePosition',[600 500 400 300]);

% figure中英混合字体的方法
% title('> 0.5\fontname{Times new roman}eV \fontname{宋体}的中子注量率 ...
% (\fontname{Times new roman}\fontname{宋体}nv)');