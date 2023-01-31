clear all;
clc;



%input for loris1 sub...
N  = 4;
eo = 0;
lon= -75;
lat= 40;
sc=  0;
fax= 1;
opt= 'GJI2011';

%%anamoly
wed1(1) = lon-1;
wed1(2) = lat-20;
wed1(3) = lon-1;
wed1(4) = lat+20;
wed1(5) = lon+1;
wed1(6) = lat+20;
wed1(7) = lon+1;
wed1(8) = lat-20;

addpath('/Users/zhendongzhang/Desktop/Glob_KAUST/plot_frederik')
addpath('/Users/zhendongzhang/Desktop/Glob_KAUST/Geometry_plot')
setenv('IFILES','/Users/zhendongzhang/Desktop/Glob_KAUST/plot_frederik/IFILES');

%%%loat plates file from Frederik
pathname=getenv('IFILES');
fid=fopen(fullfile(pathname,'PLATES','plates.mtl'),'r','b');
plates=fread(fid,[1692 2 ],'uint16');
plates(plates==0)=NaN;
plates=plates/100-90;
plon=plates(:,1);
plat=plates(:,2);
%plon(~(lon>=c11(1) & lon<=cmn(1)))=NaN;
%plat(~(lat<=c11(2) & lat>=cmn(2)))=NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  



%%LOAD EQ AND STATIONS Make sure that they're the same list
% EQSORT=load('EQ_GRE_EU.mat');
% EQSORT=EQSORT.EQSORT;
fpath  = './geom/';
eqlist = importdata(strcat(fpath,'event_600'));
% neq    = length(eqlist);
neq  = 3;
% load('STATIONS.mat')

icont=0;
for ieq=1:neq
    ieq
    eventname=strcat(fpath,'events/',eqlist{ieq});
    %%%%%%---------read CMT info-------------------
    fidevent = fopen(eventname,'rt');
    hdr = strtrim(regexp(fgetl(fidevent),'\t','split'));
    fclose(fidevent);
    
    EQALL=strsplit(char(hdr),' ');
    
    eqlat(ieq) = str2double(EQALL{8});
    eqlon(ieq) = str2double(EQALL{9});
    
    
    eqmag(ieq) = max([str2double(EQALL{11}),str2double(EQALL{12})]);
    eqrad(ieq) = (6371.1-0.001*str2double(EQALL{10}))/6371.1;
 

    stnam=strcat(fpath,'STATIONS_FLD/STATIONS.FLD.',eqlist{ieq});
    stinfo=importdata(stnam);
    stnum(ieq)=length(stinfo.data);
    
    for ist=1:stnum(ieq)
        icont=icont+1;
        stlat(icont) = stinfo.data(ist,1);
        stlon(icont) = stinfo.data(ist,2);
        strad(icont) = (6371.1-0.001*stinfo.data(ist,2))/6371.1;
        [midlat(icont), midlon(icont)] =...
                      meanm([eqlat(ieq), stlat(icont)],[eqlon(ieq), stlon(icont)]);
                  
        [midlatm1(icont), midlonm1(icont)] =...
                      meanm([eqlat(ieq), midlat(icont)],[eqlon(ieq), midlon(icont)]);
        [midlatm2(icont), midlonm2(icont)] =...
                      meanm([midlat(icont), stlat(icont)],[midlon(icont), stlon(icont)]);
    end
 end

for ieq=[neq]
    
%    figure(ieq)
    [dcol,vcol]=define_color(eqmag(1:ieq));

%%%% legend 
figure(ieq-2)
lg={'     {\itM}_{w}<1.0';...
    '1.0< {\itM}_{w}<2.0';...
    '2.0<\itM_{w}<3.0';...
    '3.0<\itM_{w}<4.0';...
    '4.0<\itM_{w}<5.0';...
    '5.0<\itM_{w}<6.0';...
    '6.0<{\itM}_{w}<7.0';...
    '7.0<\itM_{w}<8.0';...
    '    \itM_{w}<8.0';};
 for i=[6:8]  %length(dcol)
    scatter(0,3*i,i*20.0,'filled','MarkerFaceColor',dcol{i})
    text(0.1, 3*i,lg{i},'fontsize',20)
    hold on
    
end
i=8+1;
scatter(0,3*i,i*20.0,'v','MarkerEdgeColor',[17 17 17]/255)
text(0.1, 3*i,'Stations','fontsize',20)


xlim([-0.2 1])
ylim([5 25])
axis('off')
set(gca,'fontsize',20)
hold off    
    
%   axis off  
binsz = [180,360];

%midlatall=[midlat, midlatm1(1:20:end),midlatm2(1:20:end)];
%midlonall=[midlon, midlonm1(1:20:end),midlonm2(1:20:end)];

midlatall=[midlat];
midlonall=[midlon];

for i=1:length(midlonall)
    if(midlonall(i)<0.0) 
        midlonall(i) = 360.0+midlonall(i);
    end
end



figure(ieq-1)

ax=worldmap('World');

mlabel off
plabel off
% axesm miller
setm(ax,'Origin',[0,180]);
[fld, xedgs,yedgs]=histcounts2(midlatall, midlonall,binsz);
%fld(fld==0)=1;
%fld(fld>6690)=6690;
%fld(fld>500)=500;
latbintp = xedgs(1:end-1) + diff(xedgs) / 2;
lonbintp = yedgs(1:end-1) + diff(yedgs) / 2;
[latbin, lonbin] = meshgrat(latbintp,lonbintp,binsz);

fldl=log10(fld);
surfm(latbin,lonbin,fldl, 'EdgeColor', 'none')

zlimits = [0 max(max(fldl))];
demcmap(zlimits)
colormap(flipud(hot))
hcb=colorbar('Location','southoutside');
colorTitleHandle = get(hcb,'Title');
set(colorTitleHandle ,'String','Log-scale midpoint density');

hold on


load coastlines
plotm(coastlat,coastlon,'Linewidth',2)
hold on
plotm(plat,plon,'c','Linewidth',2)
 hold off
set(gca, 'fontsize',20)
setm(gca, 'FontSize', 20,'FLineWidth',2,'Grid','on','MapProjection','robinson');
set(gcf, 'Position',  [100, 100, 1133, 700])


figure(ieq+1)
ax=worldmap('World');
mlabel off
plabel off
setm(ax,'Origin',[0,180]);
load coastlines
plotm(coastlat,coastlon,'Linewidth',2)
hold on
plotm(plat,plon,'c','Linewidth',2)
 hold on
 
%%stations
 locuniq=unique([stlat(1:sum(stnum(1:ieq)))', stlon(1:sum(stnum(1:ieq)))'],'rows');
 plotm(locuniq(:,1),locuniq(:,2),'v','Color',[17 17 17]/255,'Linewidth',1.5)
 hold on
 
 for i=1:ieq
    plotm(eqlat(i),eqlon(i),'-o','MarkerFaceColor',dcol{vcol(i)},'MarkerEdgeColor',dcol{vcol(i)},'MarkerSize',1.5*eqmag(i))
    hold on
 end
 
set(gca, 'fontsize',20)
setm(gca, 'FontSize', 20,'FLineWidth',2,'Grid','on','MapProjection','robinson');
%%%standalone legend



h = zeros(4, 1);
h(1) = plot(NaN,NaN,'v','Color',[17 17 17]/255);
h(2) = plot(NaN,NaN,'.','Color',dcol{6});
h(3) = plot(NaN,NaN,'.','Color',dcol{7});
h(4) = plot(NaN,NaN,'.','Color',dcol{8});

legend(h, 'Station','5.0<M_{w}<6.0','$6.0<M_{w}<7.0$','$7.0<M_{w}<8.0$',...
    'FontSize',20,'Orientation','horizontal','Location','bestoutside',...
    'interpreter','latex','FontWeight', 'bold');


[hh,icons] = legend(h, '\boldmath{Station}','$\boldmath{5.0<M_{w}<6.0}$','$\boldmath{6.0<M_{w}<7.0}$','$\boldmath{7.0<M_{w}<8.0}$',...
    'FontSize',20,'Orientation','horizontal','Location','bestoutside',...
    'interpreter','latex','FontWeight', 'bold');

icons(6).MarkerSize = 10;
icons(6).LineWidth = 2.0;
icons(8).MarkerSize = 32;
icons(10).MarkerSize = 35;
icons(12).MarkerSize = 38;
legend boxoff
hold off
% plotm(midlat(1:sum(stnum(1:ieq))),midlon(1:sum(stnum(1:ieq))),'oc')
% hold off
set(gcf, 'Position',  [100, 100, 1133, 700])


end

