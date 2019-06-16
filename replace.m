function [R,G,B]=replace(R,G,B,avalue,mean)
[l1,l2]=size(avalue);
for i=1:l1
    R(avalue(i,1),avalue(i,2))=mean(1);
    G(avalue(i,1),avalue(i,2))=mean(2);
    B(avalue(i,1),avalue(i,2))=mean(3);
end
end

