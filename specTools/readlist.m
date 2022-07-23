function s = readlist(fileExp,varargin)
% ��ȡapg7400��list mode ģʽ�γɵ����ɸ�txt�ļ������������������׻�list
% txtÿ��Ϊ���ŷָ���ʱ�̣����������ַ
% �����Ϊ0�޷���ȡ
%
% INPUTS��
% fileExp: �ļ���������ʽ
% 'sep'��s.list����Ϊ����list
% 'spec': ��������������s.spec
% 'save': ����
% 
% OUTPUTS��
% s.list{i}: ��һ���¼�ʱ��(APG7400:ns)���ڶ���������������е�ַ
% s.spec{i}: ch1 ��һ��Ϊ��ַ���ڶ��м���
%
flag_sep = sum(strcmp(varargin,'sep')); % �Ƿ�list��Ϊ���Ե�
flag_spec = sum(strcmp(varargin,'spec')); % �Ƿ�����������
dir1 = dir(fileExp);
allList = [];
tic;
for i = 1:length(dir1)
    disp(['Reading ',dir1(i).name,'(',num2str(i),'/',num2str(length(dir1)),')']);
    toc;
    allList = [allList;importdata(dir1(i).name)];
end
allList = sortrows(allList); % ��ʱ�̴�С��������
ch_low = min(allList(:,2));ch_high = max(allList(:,2)); 

if flag_spec || flag_sep
    for i = ch_low:ch_high
        s.list{i} = allList(find(allList(:,2)==i),:);
        maxCh = max(s.list{i}(:,3));
        j = 2;
        while j < maxCh % Ѱ������ַj
            j = j*2;
        end
        ss = histogram(s.list{i}(:,3),0:1:j);
        s.spec{i} = [ss.BinEdges(2:end)',ss.Values'];
    end
else
    s.list = allList;
end

if ~flag_sep
    s.list = allList; % �ϲ�list
end

if sum(strcmp(varargin,'save'))
    % ��"-"���ҵ����һ��"-"��û�еĻ������һ��'.'
    pos1 = find(dir1(1).name=='-');
    if isempty(pos1)
        pos1 = find(dir1(1).name=='.');
        saveName = dir1(1).name(1:pos1(end)-1);
    else
        saveName = dir1(1).name(1:pos1(end)-1);
    end
    disp('Saving to .mat file...');
    save([saveName,'.mat'],'s');
end
disp('Finish reading list data');
end % of the function
