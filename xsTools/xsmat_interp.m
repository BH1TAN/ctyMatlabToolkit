function xsmat2 = xsmat_interp(xsmat,eAxis)
% 截面插值
% 
xsmat2 = eAxis;
for i = 1:0.5*size(xsmat,2)
    thisXs = xsmat(:,2*i-1:2*i);
    thisXs(find(thisXs(:,1)==0),:) = [];
    if length(unique(thisXs(:,1)))~=length(thisXs(:,1))
        jList = [];
        for j = 2:length(thisXs(:,1))
            if thisXs(j,1)==thisXs(j-1,1)
                jList = [jList;j];
            end
        end
        thisXs(jList,:)=[];
    end
    xsmat2(:,i+1) = interp1(thisXs(:,1),thisXs(:,2),eAxis);
end

end

