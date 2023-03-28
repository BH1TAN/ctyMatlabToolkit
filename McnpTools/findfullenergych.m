function ch = findfullenergych(spec,EMeV)
% 找到mcnp模拟的单能伽马能谱中，全能峰道址
% Input:
%      spec: 双列能谱，第一列能量MeV，第二列数量
%      EMeV: 大概的输入能量
% Outputs: 
%      ch: 全能峰道址

nRange = 1; % 寻找最大值的正负范围
[~,ch1] = min(abs(spec(:,1)-EMeV));
[~,ch2] = max(spec(ch1-nRange:ch1+nRange,2));
ch = ch1+ch2-2*nRange;
end
