function [] = decayanalysis2(dirname,specs,t,pks,energyList)
% 相比decayanalysis，给定了数据储存的文件夹和mat文件的名称：dirname
% 分析序列测量的多列能谱各峰的衰变情况
% Inputs:
%    dirname: 保存计数和拟合曲线图的文件夹
%    specs:多列矩阵，每一列是一个能谱
%    t：行向量，测量的起始时刻(s)
%    pks: 列向量，峰的大致中心道址
%    energyList： 列向量，单位MeV，对应的行号的能量
% Outputs:
%    "decayAnalysis.mat"数据库文件，所有使用到的参数和结果

mkdir(dirname);
roi = round([pks-0.01*pks,pks+0.01*pks]); % pks的乘数是个经验参数，大致将FWTM覆盖
mat_gross = zeros(size(roi,1),size(specs,2));
mat_net   = zeros(size(roi,1),size(specs,2));
mat_gauss = zeros(size(roi,1),size(specs,2));
mat_gauss_bkgd = zeros(size(roi,1),size(specs,2));
for i = 1:size(roi,1)
    mat_gross(i,:) = sum(specs(roi(i,1):roi(i,2),:),1);
end
for i = 1:size(roi,1)
    for j = 1:size(specs,2)
        mat_net(i,j) = getnet(specs(:,j),pks(i),2);
        clear h;
        [h,mat_gauss(i,j),mat_gauss_bkgd(i,j),sigma(i,1),xpeak(i,1),~] = fitPeak(roi(i,1):roi(i,2),specs(roi(i,1):roi(i,2),j),0);
        saveas(h,[dirname,'/peakch',num2str(pks(i)), ...
            'specNo',num2str(j),'-gaussFit.png']);
        disp(['fitting peak No.', num2str(i),'/',num2str(size(roi,1)), ...
            ' of spec No.',num2str(j),'/',num2str(size(specs,2))]);
        close all;
    end
end

%% 画能谱和roi
sumSpec = sum(specs,2);
h = figure;
semilogy(energyList(1:length(sumSpec)),sumSpec,'b-');hold on;
xlabel('Energy(MeV)');ylabel('Count in the whole time');
for i = 1:size(roi,1)
    semilogy(energyList(roi(i,1):roi(i,2)),sumSpec(roi(i,1):roi(i,2)),'r.');
end
saveas(h,[dirname,'\0sumSpec.png']);

%% 分析衰变
param_gross = zeros(size(pks,1),4);
param_net = zeros(size(pks,1),4);
param_gauss = zeros(size(pks,1),4);
for i = 1:size(pks,1)
    [h,cfun,gof] = decaycurve(mat_gross(i,:),t);
    saveas(h,[dirname,'\decayCurve-gross-ch',num2str(pks(i,1)),'.png']);
    param_gross(i,1) = cfun.halflife; % unit: s
    param_gross(i,2) = cfun.a;
    param_gross(i,3) = cfun.b;
    param_gross(i,4) = gof.rsquare;
    
    [h,cfun,gof] = decaycurve(mat_net(i,:),t);
    saveas(h,[dirname,'\decayCurve-net-ch',num2str(pks(i,1)),'.png']);
    param_net(i,1) = cfun.halflife; % unit: s
    param_net(i,2) = cfun.a;
    param_net(i,3) = cfun.b;
    param_net(i,4) = gof.rsquare;
    
    [h,cfun,gof] = decaycurve(mat_gauss(i,:),t);
    saveas(h,[dirname,'\decayCurve-gauss-ch',num2str(pks(i,1)),'.png']);
    param_gauss(i,1) = cfun.halflife; % unit: s
    param_gauss(i,2) = cfun.a;
    param_gauss(i,3) = cfun.b;
    param_gauss(i,4) = gof.rsquare;
    
    disp(['Analyzing decay peak No. ',num2str(i),'/',num2str(size(pks,1))]);
end
save([dirname,'-decayAnalysis.mat']);

end
