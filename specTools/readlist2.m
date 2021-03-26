function s = readlist2(fileExp,saveName)
% ��ȡapg7400��list mode ģʽ�γɵ����ɸ�txt�ļ����ϲ�Ϊ3�о��󣬲���������
% ���readlist,����˲�ͬ�������list
% �������׽ṹ��
% list�����ܳ�����Ҫע��
% Ŀǰ���ܶ�ȡch0����ֵ,APG7400Ҳû�е�0��
%
% INPUTS��
% fileExp: �ļ���������ʽ
%
% OUTPUTS��
% s.list{1}: ch1 ��һ���¼�ʱ��(ns)���ڶ���������������е�ַ
% s.spec{1}: ch1 ��һ��Ϊ��ַ���ڶ��м���

dir1 = dir(fileExp); % �����ж��txt�ļ�
s.list = {};
s.spec = {};
allList = [];
tic;
disp('Start reading');
for i = 1:length(dir1)
    allList = [allList;importdata(dir1(i).name)];
    disp(['Finish reading ',dir1(i).name,'(',num2str(i),'/',num2str(length(dir1)),')']);
    toc;
end
ch_low = min(allList(:,2));ch_high = max(allList(:,2));
for i = ch_low:ch_high
    s.list{i} = allList(find(allList(:,2)==i),:);
    maxCh = max(s.list{i}(:,3));
    j = 2;
    while j < maxCh % Ѱ����������ַ
        j = j*2;
    end
    ss = histogram(s.list{i}(:,3),0:1:j);
    s.spec{i} = [ss.BinEdges(2:end)',ss.Values'];
end
disp('Saving list data to .mat file...');
toc;
save(saveName,'s');
disp('Finish reading list data');
end % of the function
