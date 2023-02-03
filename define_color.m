function [dcol,vcol]=define_color(vmag)

dcol{1}=[0.75, 0, 0.75];
dcol{2}=[0.8500, 0.3250, 0.0980];
dcol{3}=[0.75, 0.75, 0];
dcol{4}=[0, 0.75, 0.75];
dcol{5}=[0, 0, 1];
dcol{6}=[1, 0, 0];
dcol{7}=[0, 0.5, 0];
dcol{8}=[0.6350, 0.0780, 0.1840];
dcol{9}=[0.25, 0.25, 0.25];

for i=1:length(vmag)
    if(vmag(i) <=1)
        vcol(i)=1;
    elseif(vmag(i) <=2 && vmag(i) >1)
        vcol(i)=2;
    elseif(vmag(i) <=3 && vmag(i) >2)
        vcol(i)=3;
    elseif(vmag(i) <=4 && vmag(i) >3)
        vcol(i)=4;
    elseif(vmag(i) <=5 && vmag(i) >4)
        vcol(i)=5;
    elseif(vmag(i) <=6 && vmag(i) >5)
        vcol(i)=6;
    elseif(vmag(i) <=7 && vmag(i) >6)
        vcol(i)=7;
    elseif(vmag(i) <=8 && vmag(i) >7)
        vcol(i)=8;
    else
        vcol(i)=9;
    end
end

