function out = unitprefix(in)
% 单位前缀与对应数量的相互转化
% 可输入：
% 纯数字
% 纯单位前缀（字符串）
%
% 需要考察的测试输入：
% 1e30
% 1e-30
% 1e-24
% 1e24
% 1e-5
% 1e-4
% 1e4
% 1e5
% 'm'
if isempty(in)
    out = 1;
elseif ischar(in)
    % 字符
    in = in(isstrprop(in,'alphanum'));
    switch in
        case ''
            out = 1;
        case 'Y' % yotta	Y	Septillion
            out = 1e24;
        case 'Z' % zetta	Z	Sextillion
            out = 1e21;
        case 'E' % exa	E	Quintillion
            out = 1e18;
        case 'P' % peta	P	Quadrillion
            out = 1e15;
        case 'T' % tera	T	Trillion
            out = 1e12;
        case 'G' % giga	G	Billion
            out = 1e9;
        case 'M' % mega	M	Million
            out = 1e6;
        case 'ma' % myria	ma	Ten-thousand
            out = 1e4;
        case 'k' % kilo	k	Thousand
            out = 1e3;
        case 'h' % hecto	h	Hundred
            out = 1e2;
        case 'da' % deca	da	Ten
            out = 1e1;
        case 'd' % deci	d	Tenth
            out = 1e-1;
        case 'c' % centi	c	Hundredth
            out = 1e-2;
        case 'm' % milli	m	Thousandth
            out = 1e-3;
        case 'mo' % myrio	mo	Ten-thousandth
            out = 1e-4;
        case 'u' % micro	u	Millionth
            out = 1e-6;
        case 'miu' % micro	u	Millionth
            out = 1e-6;
        case 'n' % nano	n	Billionth
            out = 1e-9;
        case 'p' % pico	p	Trillionth
            out = 1e-12;
        case 'f' % femto	f	Quadrillionth
            out = 1e-15;
        case 'a' % atto	a	Quintillionth
            out = 1e-18;
        case 'z' % zepto	z	Sextillionth
            out = 1e-21;
        case 'y' % yocto	y	Septillionth
            out = 1e-24;
        otherwise
            error(['Invalid input for function unitprefix: ',in]);
    end
elseif isnumeric(in)
    ord = floor(log10(abs(in))); % 量级
    num = in/10^ord;
    switch ord
        case -24
            unit = 'y';
        case -21
            unit = 'z';
        case -18
            unit = 'a';
        case -15
            unit = 'f';
        case -12
            unit = 'p';
        case -9
            unit = 'n';
        case -6
            unit = 'u';
        case -3
            unit = 'm';
        case 0
            unit = '';
        case 3
            unit = 'k';
        case 6
            unit = 'M';
        case 9
            unit = 'G';
        case 12
            unit = 'T';
        case 15
            unit = 'P';
        case 18
            unit = 'E';
        case 21
            unit = 'Z';
        case 24
            unit = 'Y';
        otherwise
            if ord < 24 && ord > -24
                switch mod(ord,3)
                    case 1
                        num = num*10;
                        ord = ord - 1;
                        
                    case 2
                        num = num*100;
                        ord = ord - 2;
                end
                unit = unitprefix(10^ord);
                unit = unit(end);
            else
                warning(['User defined function unitprefix.m ', ...
                    'could not handle >= 1e25 or <= 1e-25']);
                out = in;
                return;
            end
    end
    if in < 0
        num = num * -1;
    end
    out = [num2str(num),' ',unit];
else
    error('Invalid input for user function unitprefix');
end

end

