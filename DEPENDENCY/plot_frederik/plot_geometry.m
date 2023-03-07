clear all;
clc;

%define a set of colors##
dcol{1}=[0, 0, 1];
dcol{2}=[0, 0.5, 0];
dcol{3}=[1, 0, 0];
dcol{4}=[0, 0.75, 0.75];
dcol{5}=[0.75, 0, 0.75];
dcol{6}=[0.75, 0.75, 0];
dcol{7}=[0.25, 0.25, 0.25];
dcol{8}=[0.8500, 0.3250, 0.0980];
dcol{9}=[0.6350, 0.0780, 0.1840];

setenv('IFILES','/Users/zhendongzhang/Desktop/Glob_KAUST/IFILES');


N  = 4;
eo = 0;
lon= -100;
lat= 40;
sc=  0;
fax= 1;
opt= 'GJI2011';

targetlon=-79.99;
targetlat=44.44;

%Two wedges...lon...lat..
wed1(1) = -112;
wed1(2) =  10;
wed1(3) = -80;
wed1(4) =  5;
wed1(5) = -80;
wed1(6) =  40;

wed2(1) = -60;
wed2(2) =  10;
wed2(3) = -50;
wed2(4) =  30;
wed2(5) = -90;
wed2(6) =  40;

P1=[wed1(1), wed1(2)];
P2=[wed1(3), wed1(4)];
P3=[wed1(5), wed1(6)];
P12 = P1-P2; P23 = P2-P3; P31 = P3-P1;

PP1=[wed2(1), wed2(2)];
PP2=[wed2(3), wed2(4)];
PP3=[wed2(5), wed2(6)];
PP12 = PP1-PP2; PP23 = PP2-PP3; PP31 = PP3-PP1;

%define range of chunck...
lonw = -160;
lone = -50;
lats = 10;
latn = 80;
vrang=[lonw,lone,lats,latn];
load('/Users/zhendongzhang/Desktop/Glob_KAUST/EVENTS/eq2017_mag_lat_lon_dep.mat')
eq17=table2array(eq2017);
tepcont=0;
for i=1:size(eq2017)
    lontp = eq17(i,3);
    lattp = eq17(i,2);
    magtp = eq17(i,1);
    
    P = [lontp,lattp];
  
    t = sign(det([P31;P23]))*sign(det([P3-P;P23])) >= 0 & ...
       sign(det([P12;P31]))*sign(det([P1-P;P31])) >= 0 & ...
       sign(det([P23;P12]))*sign(det([P2-P;P12])) >= 0 ;
    tt = sign(det([PP31;PP23]))*sign(det([PP3-P;PP23])) >= 0 & ...
       sign(det([PP12;PP31]))*sign(det([PP1-P;PP31])) >= 0 & ...
       sign(det([PP23;PP12]))*sign(det([PP2-P;PP12])) >= 0 ;
   
%         if(lontp >= lonw && lontp <= lone && lattp >=lats && lattp <=latn && magtp >=4.0)

    if( (t || tt) && magtp >=4.0)
        tepcont       = tepcont+1;
        vlon(tepcont) = lontp;
        vlat(tepcont) = lattp;
        vmag(tepcont) = magtp;
        vrad(tepcont) = (6371.1-eq17(i,4))/6371.1;
        vdep(tepcont) = eq17(i,4);
        vdis(tepcont) = greatCircleDistance(lattp,lontp,targetlat,targetlon,6371.0);
    end
end
neq = tepcont;
for i=1:neq
%     vlon(i)=eq2017{i,3};
%     vlat(i)=eq2017{i,2};
%     vmag(i)=abs(eq2017{i,1})+0.01;
%     vrad(i)=(6378.1-eq2017{i,4})/6378.1;
    if(vmag(i) <=1)
        vcol(i)=1;
    elseif(vmag(i) <=2 && vmag(i) >=1)
        vcol(i)=2;
    elseif(vmag(i) <=3 && vmag(i) >=2)
        vcol(i)=3;
    elseif(vmag(i) <=4 && vmag(i) >=3)
        vcol(i)=4;
    elseif(vmag(i) <=5 && vmag(i) >=4)
        vcol(i)=5;
    elseif(vmag(i) <=6 && vmag(i) >=5)
        vcol(i)=6;
    elseif(vmag(i) <=7 && vmag(i) >=6)
        vcol(i)=7;
    elseif(vmag(i) <=8 && vmag(i) >=7)
        vcol(i)=8;
    else
        vcol(i)=9;
    end
        
end

figure(1)
subplot(131)
histogram(vmag)
xlabel('Magnitude')
ylabel('Count')
set(gca,'fontsize',16)

subplot(132)
histogram(vdep)
xlabel('Depth')
ylabel('Count')
set(gca,'fontsize',16)

subplot(133)
histogram(vdis)
xlabel('Dis. to Pittsburgh')
ylabel('Count')

set(gca,'fontsize',16)
hold off

figure(2)
loris1(N,eo,lon,lat,sc,fax,opt,vlon,vlat,vrad,vmag,vcol,dcol,vrang,neq,wed1,wed2);

% figure(3)
% for i=1:9
%    scatter(1,i,i*10,'filled','MarkerFaceColor',dcol{i});
%    text(1+0.1, i, 'M'+string(i),'Fontsize',16);
%    hold on
% end
% ylim([0 10])
axis off