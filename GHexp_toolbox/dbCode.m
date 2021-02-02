function dbCode(delay,broaden)
% 
% ������Ҫ����ʱչ���������λus������ʾģ�鲦��
% max:26.2143ms

delay = round(delay/0.1);
broaden = round(broaden/0.1);
if delay > 262143 ||broaden > 262143
    disp('Error: �������ֵ26.2143ms');
    return;
end
delayCode = num2str(dec2bin(delay,18));
broadenCode = num2str(dec2bin(broaden,18));
delayCode(1,15:20) = delayCode(1,13:18);
delayCode(1,8:13) = delayCode(1,7:12);
delayCode(1,[7,14])=[' ',' '];
broadenCode(1,15:20) = broadenCode(1,13:18);
broadenCode(1,8:13) = broadenCode(1,7:12);
broadenCode(1,[7,14])=[' ',' '];
disp('-----------------------------------');
disp(['�ӳ٣�',num2str(delay/10),'us']);
disp(['�ӳٲ���(UPPER->LOWER)��',num2str(delayCode)]);
disp(['չ��',num2str(broaden/10),'us']);
disp(['չ����(H->L)��',num2str(broadenCode)]);
disp('-----------------------------------');
end
