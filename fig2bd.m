clear all;
clc;
%%% plot figure 2b for the paper ....
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
cgrey=[0.85 0.85 0.85];



[dcol,vcol]=define_color(6);

evtID="C201006240532A";

fwindow = strcat('/Volumes/zzd/temp/dat_M25/',evtID,'/window/');
fobs    = strcat('/Volumes/zzd/temp/dat_M25/',evtID,'/obs/');

%%%for filtered data only
evtnam=strcat('/Volumes/zzd/temp/dat_M25/',evtID,'/geom/',evtID);
stnam =strcat('/Volumes/zzd/temp/dat_M25/',evtID,'/geom/','STATIONS.FLD.',evtID);

%scalfac=3.0e-6;
scalfac=1.0e6;
compz='BHN';
compz='BHE';

evt    = importfile_event(evtnam, [1, Inf]); 
stlist = importfile_station_string(stnam, [1, Inf]);

evt_lat= evt{5,2};
evt_lon= evt{6,2};
evt_dep= evt{7,2};
hdur=evt{4,2};

evt_UTCtmp=strsplit(evt{1,1});
year=str2double(evt_UTCtmp(3));
month=str2double(evt_UTCtmp(4));
day=str2double(evt_UTCtmp(5));
hour=str2double(evt_UTCtmp(6));
minutes=str2double(evt_UTCtmp(7));
sec=str2double(evt_UTCtmp(8));
evt_UTCtmpp= datenum(year,month,day,hour,minutes,sec);
evt_UTC=datetime(evt_UTCtmpp,'ConvertFrom','datenum');

nst=length(stlist);
for ist=1:nst
   st_lat(ist) =str2double(stlist(ist,3));
   st_lon(ist) =str2double(stlist(ist,4));
   st_elv(ist) =str2double(stlist(ist,5));
   stnam(ist)  =strcat(strrep(stlist(ist,2),' ',''),'.',strrep(stlist(ist,1),' ',''));
   stnam2(ist)  =strcat(strrep(stlist(ist,1),' ',''),'.',strrep(stlist(ist,2),' ',''));
   
  
   fdwin=strcat(fwindow,'/',stnam(ist),'.MXZ','.adj');
   fdobsz=strcat(fobs,'/',stnam(ist),'.MXZ','.adj');
   fdobsr=strcat(fobs,'/',stnam(ist),'.MXR','.adj');
   fdobst=strcat(fobs,'/',stnam(ist),'.MXT','.adj');


   if isfile(fdobsz) && isfile(fdobsr) && isfile(fdobst) && isfile(fdwin)
       [tvec(:), dwin(:,ist)]=read_ascii_traces(fdwin);
       [tvec(:), dobsz(:,ist)]=read_ascii_traces(fdobsz);
       [tvec(:), dobsr(:,ist)]=read_ascii_traces(fdobsr);
       [tvec(:), dobst(:,ist)]=read_ascii_traces(fdobst);
      %[tvec(:), dadp(:,ist)]=read_ascii_traces(fdadp);
   else
       dwin(1:18751,ist) = 0.0;
       dobsz(1:18751,ist) = 0.0;
       dobsr(1:18751,ist) = 0.0;
       dobst(1:18751,ist) = 0.0;

   end

   
   [dis(ist), az(ist)] = haversine([evt_lat, st_lat(ist)], [evt_lon,st_lon(ist)]);
    
    [dis_sort, dis_indx] = sort(dis);
    [az_sort, az_indx]  = sort(az);
end

%2010 06 24 05 32 27.40
cgrey=[0.7 0.7 0.7];

cthred=0.002;
hdur15=1.5*hdur;
icont=0;
iicont=0;
%%
 %for isel=130:20:260
     
isel=369

iicont=iicont+1;
[midlat(iicont), midlon(iicont)] =...
                      meanm([evt_lat, st_lat(dis_indx(isel))],[evt_lon, st_lon(dis_indx(isel))]);
                            
                  
  stsel_lon(iicont) = st_lon(dis_indx(isel));
  stsel_lat(iicont) = st_lat(dis_indx(isel));
   
    if(midlon(iicont)<0.0) 
        midlon(iicont) = 360.0+midlon(iicont);
    end

  
    txt_st2=stnam2(dis_indx(isel)); %station name
    
    
    icont=icont+1.2;
    disc=410;
    PPtime=cal_ptraveltimes(evt_dep,dis_sort(isel),'PP',disc);
    PStime=cal_ptraveltimes(evt_dep,dis_sort(isel),'PS',disc);
    SPtime=cal_ptraveltimes(evt_dep,dis_sort(isel),'SP',disc);
    SStime=cal_ptraveltimes(evt_dep,dis_sort(isel),'SS',disc);
    Pdifftime=cal_ptraveltimes(evt_dep,dis_sort(isel),'Pdiff',disc);
    Sdifftime=cal_ptraveltimes(evt_dep,dis_sort(isel),'Sdiff',disc);
    S660S=cal_ptraveltimes(evt_dep,dis_sort(isel),'SxS',660.0);
    S410S=cal_ptraveltimes(evt_dep,dis_sort(isel),'SxS',410.0);
    S1kS=cal_ptraveltimes(evt_dep,dis_sort(isel),'SxS',1000.0);


    PT=[PPtime PPtime];    
    ST=[SStime SStime];  
    PdT=[Pdifftime Pdifftime]; 
    SdT=[Sdifftime Sdifftime];
    S410ST=[S410S S410S];
    S660ST=[S660S S660S];
    S1kST=[S1kS S1kS];
    PST=[PStime PStime];
    SPT=[SPtime SPtime];
    
    
    
    PPx=PPtime;
    SSx=SStime;
    PSx=PStime;
    SPx=SPtime;
    Pdiffx=Pdifftime;
    Sdiffx=Sdifftime;
    S660Sx=S660S;
    S410Sx=S410S;
    S1kSx=S1kS;

    labx=100+450;%location of text
    labdis=40.0*60.0-350;
   

    vline=[-scalfac*3e-6 scalfac*3e-6];
figure(1)
t=tiledlayout(3,1,'TileSpacing','compact');
nexttile,

% temptraceo=(dobsz(:,dis_indx(isel)));
% plot(tvec,temptraceo,'k','Linewidth',1.5)
% hold on


temptrace=(dobsz(:,dis_indx(isel))*scalfac);
plot(tvec, temptrace,'Color',cgrey,'Linewidth',1.)
hold on
temptrace=(dwin(:,dis_indx(isel)).*dobsz(:,dis_indx(isel))*scalfac);
temptrace(abs(temptrace)<0.0000000001)=NaN;

%determin the start and end of window
radlen   = 400;
wintp    = diff(dwin(:,dis_indx(isel)));
loc_1st  = find(wintp,1,'first');
loc_lst  = find(wintp,1,'last');
[junk,loc_2nd] = min(wintp(loc_1st:loc_lst));
loc_2nd  = loc_1st+loc_2nd+radlen;

[junk,loc_3rd] = min(wintp(loc_2nd:loc_lst));
loc_3rd  = loc_3rd+loc_2nd+radlen;




plot(tvec(1:loc_2nd), temptrace(1:loc_2nd),'color',dcol{6},'Linewidth',1.)
hold on
plot(tvec(loc_2nd+1:loc_3rd), temptrace(loc_2nd+1:loc_3rd),'color',dcol{7},'Linewidth',1.)
hold on
plot(tvec(loc_3rd+1:end), temptrace(loc_3rd+1:end),'color',dcol{8},'Linewidth',1.)
hold on



plot(PT,vline,'--','color',cgrey,'Linewidth',0.5)     
hold on
plot(ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(PdT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(SdT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S410ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S660ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S1kST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(PST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(SPT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold off

ccont = scalfac*3e-6*1.1;
text(PPx,ccont,'PP','FontSize',16,'Color','k','Rotation',45)
text(SSx,ccont,'SS','FontSize',16,'Color','k','Rotation',45)
 % text(PSx,ccont,'PS','FontSize',16,'Color','red')
text(SPx,ccont,'SP','FontSize',14,'Color','k','Rotation',45)

text(Pdiffx,ccont,'Pdiff','FontSize',16,'Color','k','Rotation',45)
text(Sdiffx,ccont,'Sdiff','FontSize',16,'Color','k','Rotation',45)
text(S410Sx,ccont,'S410S','FontSize',12,'Color','k','Rotation',45)
text(S660Sx,ccont,'S660S','FontSize',12,'Color','k','Rotation',45)
text(S1kSx,ccont,'S1000S','FontSize',12,'Color','k','Rotation',45)
   


txt_st=stnam(dis_indx(isel));
diss=sprintf('%.1f', dis_sort(isel));
txt_dis=strcat(diss, '^{\circ}');

text(labx-500,ccont*1.1,txt_st,'FontSize',16)
text(labx-20,ccont*1.2,txt_dis,'FontSize',16)

text(labx-400,scalfac*3e-6*0.7,'BHZ','FontSize',16)

xlim([0, 3000]) 

ylim([-scalfac*3e-6 scalfac*3e-6])
set(gca,'xtick',[])

set(gca, 'fontsize',16)

nexttile,

temptrace=(dobsr(:,dis_indx(isel))*scalfac);
plot(tvec, temptrace,'Color',cgrey,'Linewidth',1.)
hold on
temptrace=(dwin(:,dis_indx(isel)).*dobsr(:,dis_indx(isel))*scalfac);
temptrace(abs(temptrace)<0.0000000001)=NaN;
plot(tvec(1:loc_2nd), temptrace(1:loc_2nd),'color',dcol{6},'Linewidth',1.)
hold on
plot(tvec(loc_2nd+1:loc_3rd), temptrace(loc_2nd+1:loc_3rd),'color',dcol{7},'Linewidth',1.)
hold on
plot(tvec(loc_3rd+1:end), temptrace(loc_3rd+1:end),'color',dcol{8},'Linewidth',1.)
hold on

plot(PT,vline,'--','color',cgrey,'Linewidth',0.5)     
hold on
plot(ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(PdT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(SdT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S410ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S660ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S1kST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(PST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(SPT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold off

xlim([0, 3000]) 
ylim([-scalfac*3e-6 scalfac*3e-6])
set(gca,'xtick',[])

set(gca, 'fontsize',16)
text(labx-400,scalfac*3e-6*0.7,'BHR','FontSize',16)
nexttile,
temptrace=(dobst(:,dis_indx(isel))*scalfac);
plot(tvec, temptrace,'Color',cgrey,'Linewidth',1.)
hold on
temptrace=(dwin(:,dis_indx(isel)).*dobst(:,dis_indx(isel))*scalfac);
temptrace(abs(temptrace)<0.0000000001)=NaN;


plot(tvec(1:loc_2nd), temptrace(1:loc_2nd),'color',dcol{6},'Linewidth',1.)
hold on
plot(tvec(loc_2nd+1:loc_3rd), temptrace(loc_2nd+1:loc_3rd),'color',dcol{7},'Linewidth',1.)
hold on
plot(tvec(loc_3rd+1:end), temptrace(loc_3rd+1:end),'color',dcol{8},'Linewidth',1.)
hold on

plot(PT,vline,'--','color',cgrey,'Linewidth',0.5)     
hold on
plot(ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(PdT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(SdT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S410ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S660ST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(S1kST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(PST,vline,'--','color',cgrey,'Linewidth',0.5)  
hold on
plot(SPT,vline,'--','color',cgrey,'Linewidth',0.5)  
hold off

    
text(labx-400,scalfac*3e-6*0.7,'BHT','FontSize',16)
%text(labx-20,0.2,datestr(evt_UTC),'FontSize',16)
%


xlim([0, 3000]) 
xlab=strcat('Time (s) since ',32,datestr(evt_UTC));
xlabel(xlab)
ylim([-scalfac*3e-6 scalfac*3e-6])
set(gca, 'fontsize',16)


ylabel(t,'Displacement (\mum)', 'fontsize',16);

% set(gcf, 'Position',  [100, 100, 1400, 800])
%%
set(gcf, 'Position',  [100, 100, 600, 400])
% legend('Observed','Syn. M25', 'Syn. PREM','Syn. s362ani')


figure(10)

ax=worldmap('World');

mlabel off
plabel off
setm(ax,'Origin',[0,180]);

load coastlines
 plotm(coastlat,coastlon,'Linewidth',1)
 hold on
% plotm(plat,plon,'c','Linewidth',2)
%  hold on
 
%%stations
%  locuniq=unique([stlat(1:sum(stnum(1:ieq)))', stlon(1:sum(stnum(1:ieq)))'],'rows');
[lattrkgc,lontrkgc] = track2(evt_lat,evt_lon,stsel_lat(:)',stsel_lon(:)');
plotm(lattrkgc,lontrkgc,'--k','Linewidth',1)

hold on
 h(1)=plotm(evt_lat,evt_lon,'o','MarkerFaceColor','black','MarkerEdgeColor','black','MarkerSize',10);

 
 hold on
 h(2)=plotm(midlat(:)',midlon(:)','d','MarkerEdgeColor','blue','Linewidth',1,'MarkerSize',10);
hold on
 h(3)=plotm(stsel_lat(:)',stsel_lon(:)','v','Color','black','Linewidth',1,'MarkerSize',10);
 
 hold off
% plotm(midlat(1:sum(stnum(1:ieq))),midlon(1:sum(stnum(1:ieq))),'oc')
% hold off
set(gca, 'fontsize',16)
setm(gca, 'FontSize', 16,'FLineWidth',2,'Grid','on','MapProjection','robinson')

% legend(h(1:3), 'Earthquake','Midpoint','Station','Orientation','horizontal','Location','bestoutside','FontSize', 16)
% set(gcf, 'Position',  [100, 100, 600, 600])
set(gcf, 'Position',  [100, 100, 320, 200])