function [tally1,tally2] = readtalysXS(filename)
% Read talys output for cross sections
%
%
tally1 = zeros(1,9);
tally2 = zeros(1,7);
targetStr = ' 1. Total (binary) cross sections';
if ~exist(filename)
    tally1 = [];
    tally2 = [];
    return;
end
fid = fopen(filename,'r');
while ~feof(fid)
    thisLine = fgetl(fid);
    if strncmp(thisLine,targetStr,length(targetStr))
        break;
    end
end
while ~feof(fid)
    thisLine = fgetl(fid);
    pos = strfind(thisLine,'=');
    switch length(pos)
        case 0
        case 1
            if contains(thisLine,' Total        ')
                tally1(1,1) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'Shape elastic')
                tally1(1,2) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'Reaction     ')
                tally1(1,3) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'     Compound elastic')
                tally1(1,4) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'     Total elastic')
                tally1(1,5) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'     Non-elastic')
                tally1(1,6) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'       Direct')
                tally1(1,7) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'       Pre-equilibrium')
                tally1(1,8) = str2num(thisLine(pos+1:end));
            elseif contains(thisLine,'       Compound non-el')
                tally1(1,9) = str2num(thisLine(pos+1:end));
                
            end
        case 2
            if contains(thisLine,' gamma   ')
                tally2(1,1) = str2num(thisLine(11:23));
            elseif contains(thisLine,' neutron ')
                tally2(1,2) = str2num(thisLine(11:23));
            elseif contains(thisLine,' proton  ')
                tally2(1,3) = str2num(thisLine(11:23));
            elseif contains(thisLine,' deuteron')
                tally2(1,4) = str2num(thisLine(11:23));
            elseif contains(thisLine,' triton  ')
                tally2(1,5) = str2num(thisLine(11:23));
            elseif contains(thisLine,' helium-3')
                tally2(1,6) = str2num(thisLine(11:23));
            elseif contains(thisLine,' alpha   ')
                tally2(1,7) = str2num(thisLine(11:23));
            end
        otherwise
            error('Error in readtalysXS.m');
    end
    
end
fclose(fid);

end
