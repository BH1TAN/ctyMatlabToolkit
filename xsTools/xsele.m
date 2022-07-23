function xs = xsele(mat,abu)
% 基于丰度计算元素截面
xs = 0*mat(:,1);
for i = 1:size(abu,1)
    xs = xs + abu(i,2)*mat(:,i+1);
end
xs = xs/sum(abu(:,2));
xs = [mat(:,1),xs];
end

