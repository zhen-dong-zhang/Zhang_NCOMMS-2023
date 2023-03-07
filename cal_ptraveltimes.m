function tt=cal_ptraveltimes(evt_depth,dist,phaname,disc)
    %"P","S","PP","SS",...
    %"Pdiff","Sdiff"
addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities')
addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities/Ray1d')
% plot travel times of selectedseismic phases
% Chunquan Yu, 2020-08-01
% yucq@sustech.edu.cn


evdp = evt_depth; % event depth
imodel = 'prem'; % velocity model, 'prem','ak135','iasp91'
em = set_vmodel_v2(imodel);
em = refinemodel(em,5); % refine model to layer thickness of maximum=10 km
%
np = 1000;

r2d = 180/pi;
    
% phasenames = {
%     'P','S',...
%     'Pdiff','Sdiff',...
%     'PP','SS','PS','SP',...
%     'PcP','ScS','PcS','ScP','ScSScS'
%     };

phasenames = {
    phaname
    };

for i = 1:length(phasenames)
    
    [ rayp, taup, Xp ] = phase_taup( phasenames{i}, evdp, np, em, disc );

    % get travel time and epicentral distance
    phases(i).t0 = taup + rayp.* Xp;
    phases(i).d0 = Xp*r2d;
    
    % if distance larger than 180 degrees, use the minor arc
    ind = find(phases(i).d0>180);
    phases(i).d0(ind) = 360-phases(i).d0(ind);
    
    
    phases(i).name = phasenames{i};
    phases(i).color = [rand rand rand];
end


for i = 1:length(phases)
    
    
    if isempty(phases(i).t0)
        continue;
    end
    
    [~,idx]=min(unique(abs(phases(i).d0-dist),'stable'));
    
     phases(i).name;
   tt=  phases(i).t0(idx);%return traveltime for the phase;
     phases(i).d0(idx);
    
%     h(i) = plot(phases(i).d0,phases(i).t0/60,'color',phases(i).color,'markersize',2,'linewidth',1);
%     ind = round((1+length(phases(i).d0))/2);
%     text(phases(i).d0(ind),phases(i).t0(ind)/60,phases(i).name,'color',phases(i).color,'Fontsize',10);

   
end
   




end

