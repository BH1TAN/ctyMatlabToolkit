function specSeq = loadSpecSeq(fileOrFolderName)
% ���뱾�׻���Ʒnml�ļ������ļ�����������bkgd,smpl����ÿһ��Ϊһ��׼������
%

if contains(fileOrFolderName,'eV-nml') % ��׼���ļ�
    load([fileOrFolderName,'.mat']);
    specSeq = sgnl;
else % �ļ���
    orgnSpecSeq = getOrgnSeq(fileOrFolderName,1);
    nmlSpecSeq = nmlOrgnSeq(orgnSpecSeq,1);
end


end
