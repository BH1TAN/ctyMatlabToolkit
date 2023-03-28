function newSpec = addGaussBroaden2( ebin,spec,method,a,b,c )
% 为多个能谱增加高斯展宽
% 注意能谱计数若相差过大的话，用时会因计数截断偏小而增长
%
% INPUTS:
% ebin: MeV能量轴，列向量
% spec: 多列计数，每一列为待展宽能谱
% method：1.平滑展宽 2.抽样（要求spec第二列为自然数）
% a,b,c: parameters in FWHM=a+b*sqrt(E+cE^2)
%        林谦老师ppt推荐NaI：a=0.01; b=0.05; c=0.4;
%        HPGe34#实测：a=0.00173; b=0.00106; c=0.07319;
% 
% OUTPUTS:
% newSpec: 多列计数，展宽后能谱
if size(ebin,2)~=1
    ebin = ebin';
    if size(ebin,2)~=1
        newSpec = 0;
        warning('addGaussbroaden2的ebin参数应为列向量');
    end
end
if size(spec,1)~=size(ebin,1)
    spec = spec';
    if size(spec,1)~=size(ebin,1)
        newSpec = 0;
        warning('addGaussbroaden2的spec参数输入有误');
    end
end
newSpec = 0*spec;
energyStep = ebin(2,1)-ebin(1,1);
countcut = min(sum(spec,1)/(size(spec,1)^2)); % countcut: 小于多少的数视为0
switch method
    case 1 % 平滑展宽
        for i = 1:size(ebin,1)
            if ~mod(i,100)
                disp(['Gauss Broadening:',num2str(i),'/',num2str(size(spec,1))]);
            end
            if all(~spec(i,:))
                continue;
            end
            fwhm = a+b*sqrt(ebin(i,1)+c*ebin(i,1)^2);
            sigma = 0.42466*fwhm; % sigma = fwhm/(2*sqrt(2*ln2))
            thisResponse = zeros(size(newSpec,1),1);
            jFirst = norminv(countcut/min(sum(spec(:,2),1)),ebin(i,1),sigma); % 计数截断对应的能量值下阈
            jFirst = sum(ebin(:,1)<jFirst)+1; % 最小截断对应的行号
            jEnd = norminv(1-countcut/min(sum(spec(:,2),1)),ebin(i,1),sigma); % 计数截断对应的能量值上阈
            jEnd = sum(ebin(:,1)<jEnd)+1; % 最小截断对应的行号
            for j = jFirst:jEnd
                if j == 1
                    thisResponse(1,1) =  ...
                        (normcdf(ebin(1,1),ebin(i,1),sigma) - normcdf(0,ebin(i,1),sigma));
                else
                    thisResponse(j,1) =  ...
                        (normcdf(ebin(j,1),ebin(i,1),sigma) - normcdf(ebin(j-1,1),ebin(i,1),sigma));
                end
            end
            newSpec = newSpec + thisResponse*spec(i,:);
        end
        % newSpec(find(newSpec(:,2)<countcut),2) = 0; % 删除计数小于计数截断的点
    case 2 % 抽样
        error('addGaussbroaden2暂不支持抽样（method=2）');
%         spec = round(spec);
%         for i = 1:size(spec,1)
%             fwhm = a+b*sqrt(spec(i,1)+c*spec(i,1)^2);
%             sigma = 0.42466*fwhm; % sigma = fwhm/(2*sqrt(2*ln2))
%             for j = 1:spec(i,2)
%                 pos = norminv(rand,spec(i,1)+0.5*energyStep,sigma);
%                 if pos < newSpec(1,1)
%                     pos = newSpec(1,1);
%                 end
%                 chch = sum(spec(:,1)<=pos);
%                 newSpec(chch,2) = newSpec(chch,2) + 1;
%             end
%         end
    otherwise
        error('addGaussbroaden2的method输入错误');
end
