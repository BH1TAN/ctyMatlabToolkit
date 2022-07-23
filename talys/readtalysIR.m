function [tally,flag] = readtalysIR(filename)
% Read talys output for reation channel and isomeric ratio
% talys 给出的截面单位是mb,本代码将其改为b
% 注意：talys不给出反应后剩余核基态的半衰期
%
targetStr = '                 cross section       cross section  ratio';
inputStr = ' USER INPUT FILE';
t.z_i = [];
t.a_i = [];
t.particle = [];
t.EMeV = [];
t.z = [];
t.a = [];
t.nuclide = [];
t.xs = [];
t.level = [];
t.isomeric_xs = [];
t.ir = [];
t.halflife = [];
if ~exist(filename)
    tally = [];
    flag = 0;
    return;
end
fid = fopen(filename,'r');
while ~feof(fid)
    thisLine = fgetl(fid);
    if strncmp(thisLine,inputStr,length(inputStr))
        % 找到了输入文件内容
        thisLine = fgetl(fid);
        while 1
            thisLine = fgetl(fid);
            if isempty(thisLine)
                break;
            end
            content_in = strsplit(thisLine);
            if length(content_in)>1
                if strcmp(content_in{1,2},'projectile')
                    particle = content_in{1,3};
                elseif strcmp(content_in{1,2},'element')
                    z_i = str2num(content_in{1,3});
                elseif strcmp(content_in{1,2},'mass')
                    a_i = str2num(content_in{1,3});
                elseif strcmp(content_in{1,2},'energy')
                    EMeV = str2num(content_in{1,3});
                end
            end
        end
    elseif strncmp(thisLine,targetStr,length(targetStr))
        % 找到了isomeric cross section的表头行
        fgetl(fid); % 读取空行
        while ~feof(fid)
            thisLine = fgetl(fid);%disp(thisLine);
            if isempty(thisLine)
                break;
            end
            % 处理内容
            if isempty(str2num(thisLine(19:29)))
                % isomer的行
                isomerNo = isomerNo + 1;
                t.z(end+1,1) = t.z(end,1);
                t.a(end+1,1) = t.a(end,1);
                switch isomerNo
                    case 1
                        t.nuclide{end+1,1} = [t.nuclide{end,1},'m'];
                    otherwise
                        t.nuclide{end+1,1} = [t.nuclide{end,1}(1:end-1),char('m'+isomerNo-1)];
                end
                t.xs(end+1,1) = t.xs(end,1);
            else
                isomerNo = 0;
                t.z(end+1,1) = str2num(thisLine(1:5));
                t.a(end+1,1) = str2num(thisLine(6:9));
                thisNuc = [thisLine(15:16),num2str(str2num(thisLine(12:14)))]; % avoid space in Uranium-238 and other isotopes
                t.nuclide{end+1,1} = thisNuc(isstrprop(thisNuc,'alphanum'));
                t.xs(end+1,1) = str2num(thisLine(19:29))/1000;
            end         
            t.level(end+1,1) = str2num(thisLine(30:38));
            t.isomeric_xs(end+1,1) = str2num(thisLine(39:49))/1000;
            t.ir(end+1,1) =str2num(thisLine(52:58)) ;
            if length(thisLine)>59
                t.halflife(end+1,1) = str2num(thisLine(61:73));
                if ~strcmp(thisLine(74:76),'sec')
                    error(['Please modify readtalysIR.', ...
                        ' Halflife unit is not sec. in file: ', ...
                        filename]);
                end
            else
                t.halflife(end+1,1) = nan;
            end
            % 固定的入射粒子与靶核信息
            t.z_i(end+1,1) = z_i;
            t.a_i(end+1,1) = a_i;
            t.particle{end+1,1} = particle;
            t.EMeV(end+1,1) = EMeV;
            % 处理内容毕
        end
        break;
    end
end
fclose(fid);
tally = table(t.z_i,t.a_i,t.particle,t.EMeV,t.z,t.a,t.nuclide,t.xs,t.level,t.isomeric_xs,t.ir,t.halflife);
tally.Properties.VariableNames={'z_i','a_i','particle','EMeV','z_o','a_o','isotope_o','total_xs','level','isomeric_xs','ir','halflife'};
tally(find(tally{:,'isomeric_xs'}==0),:)=[];
flag = 1;

end
