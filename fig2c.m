clear all
clc;

addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities')
addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities/ray1d')

% plot travel times of selectedseismic phases
% Chunquan Yu, 2020-08-01
% yucq@sustech.edu.cn

[dcol,vcol]=define_color(6);


evdp = 49.5; % event depth
imodel = 'prem'; % velocity model, 'prem','ak135','iasp91'
em = set_vmodel_v2(imodel);
% em = refinemodel(em,10); % refine model to layer thickness of maximum=10 km
np = 1000;

convdep=660;

cendis=112.5;

r2d = 180/pi;
    
% phasenames = {
%     'P','S',...
%     'pP','sP','sS','pS',...
%     'Pdiff','Sdiff',...
%     'PP','SS','PS','SP',...
%     'PcP','ScS','PcS','ScP','ScSScS'...
%     'PKPab','PKPbc',...
%     'PKKP','SKS','SKKS',...
%     'PKiKP','PKIKP','SmSx'
%     };

phasenames = {
    'S410S','S660S','SxS','S410P','S660P','P410P','P660P','P','S','SS','PP'...
    'P','S',...
     'pP','sP','sS','pS',...
     'Pdiff','Sdiff',...
     'PS','SP',...
     'PcP','ScS','PcS','ScP','ScSScS'...
     'PKPab','PKPbc',...
     'PKKP','SKS','SKKS',...
     'PKiKP','PKIKP','SmSx'
    };
cgrey=[0.7 0.7 0.7];
for i = 1:length(phasenames)
    if i==3
       [ rayp, taup, Xp ] = phase_taup( phasenames{i}, evdp, np, em, 1000.0);
    else
       [ rayp, taup, Xp ] = phase_taup( phasenames{i}, evdp, np, em, convdep );
    end
    % get travel time and epicentral distance
    phases(i).t0 = taup + rayp.* Xp;
    phases(i).d0 = Xp*r2d;
    
    % if distance larger than 180 degrees, use the minor arc
    ind = find(phases(i).d0>180);
    phases(i).d0(ind) = 360-phases(i).d0(ind);
    
    
    phases(i).name = phasenames{i};
    phases(i).color = cgrey;
end
% phases(6).color = [1 0 0];
% phases(7).color = [1 0 1];
% 
% phases(1).color = [0 0.5 0];
% phases(2).color = [0 0.75 0];
% phases(3).color = [0 1.0 0];
% 
% phases(4).color = [0 0 0.5];
% phases(5).color = [0 0 1.0];

phases(6).color = dcol{6};
phases(7).color = dcol{6};

phases(1).color = dcol{8};
phases(2).color = dcol{8};
phases(3).color = dcol{8};

phases(4).color = dcol{7};
phases(5).color = dcol{7};

%% plotting
figure;
subplot('position',[0.25 0.125 0.5 0.8]);
hold on;

%first plot everything in grey
for i = 1:length(phases)
    if isempty(phases(i).t0)
        continue;
    end
    h(i) = plot(phases(i).d0,phases(i).t0,'color',cgrey,'markersize',2,'linewidth',1);
    ind = round((1+length(phases(i).d0))/2);
  %  text(phases(i).d0(ind),phases(i).t0(ind)/60,phases(i).name,'color',phases(i).color,'Fontsize',10);
end

for i = 1:7
    if isempty(phases(i).t0)
        continue;
    end
    
    dis = phases(i).d0;
    tim = phases(i).t0;
    tim(dis<70.0) = NaN;
    
   
    for itest=1:length(dis)
       if (abs(dis(itest) -cendis)) < 0.5
        tvec(i) = tim(itest);
       end
    end
    
    
    h(i) = plot(dis,tim,'color',phases(i).color,'markersize',2,'linewidth',1);
    ind = round((1+length(phases(i).d0))/2);
  %  text(phases(i).d0(ind),phases(i).t0(ind)/60,phases(i).name,'color',phases(i).color,'Fontsize',10);
end
%%read window
%fwindow = strcat('/Volumes/zzd/temp/dat_M25/C201006240532A/window/');
fwindow = strcat('./data4paper/');

fdwin=strcat(fwindow,'/TA.Y37A.MXZ','.win');
[wtvec(:), dwin(:)]=read_ascii_traces(fdwin);
hold on
%plot(cendis*ones(length(dwin(1:60:end))),dwin(1:60:end),'--k','linewidth',2.5)

%   plot(dwin(:)*5+cendis,wtvec/60.0,'--k','linewidth',1.5)

 patch(dwin(10800:end)*5+cendis,wtvec(10800:end),dcol{8},'LineWidth',1)
 patch(dwin(7500:10800)*5+cendis,wtvec(7500:10800),dcol{7},'LineWidth',1)
 patch(dwin(1:7500)*5+cendis,wtvec(1:7500),dcol{6},'LineWidth',1)



% legend(h,phasenames,'location','eastoutside');    
legend(h,'S410S','S660S','S1000S','S410P','S660P','P410P','P660P','Location','northwest' )
set(gca,'Xtick',0:30:180);
grid on;
box on;
xlabel('Epicentral distance (^o)');
ylabel('Time (s)');
axis([0 180 200 3000]);
set(gca,'fontsize',16)
set(gcf, 'Position',  [100, 100, 400, 410])


