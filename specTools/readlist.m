function s = readlist(fileExp,varargin)
% ��ȡapg7400��list mode ģʽ�γɵ����ɸ�txt�ļ������������������׻�list
% �������׽ṹ��
% list�����ܳ�����Ҫע��
% Ŀǰ���ܶ�ȡch0����ֵ
%
% INPUTS��
% fileExp: �ļ���������ʽ
% 'sep'��s.list����Ϊ����list
% 'spec': ��������������s.spec
%
% OUTPUTS��
% s.list: ��һ���¼�ʱ��(ns)���ڶ���������������е�ַ
% s.spec{1}: ch1 ��һ��Ϊ��ַ���ڶ��м���
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

ch_low = min(allList(:,2));ch_high = max(allList(:,2));

if flag_spec || flag_sep
    for i = ch_low:ch_high
        s.list{i} = allList(find(allList(:,2)==i),:);
        maxCh = max(s.list{i}(:,3));
        j = 2;
        while j < maxCh
            j = j*2;
        end % Ѱ������ַ
        ss = histogram(s.list{i}(:,3),0:1:j);
        s.spec{i} = [ss.BinEdges(2:end)',ss.Values'];
    end
else 
    s.list = allList;
end

if ~flag_sep % ���list
    s.list = allList;
end

disp('Saving to .mat file...');
save('orgnList','s');
disp('Finish reading list data');
end % of the function
