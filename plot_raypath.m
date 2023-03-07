function [  ] = plot_raypath(evdp,dist)
addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities')

% plot seismic ray pathsof selectedseismic phases
% Chunquan Yu, 2020-08-01
% yucq@sustech.edu.cn


%evdp = 15; % event depth
imodel = 'prem'; % velocity model, 'prem','ak135','iasp91'
em = set_vmodel_v2(imodel);
% em = refinemodel(em,10); % refine model to layer thickness of maximum=10 km
np = 100;

angleoff = -60.0*pi/180;
mangle = linspace(0,150,4)*pi/180; % angle to mark on the surface
sangle = linspace(0,150,4)*pi/180; % angle to show tick

[dcol,vcol]=define_color(6);
% dist = [];
% dist = 90;
%dist = 112.5;
% dist = 90:10:140;
% dist = 0:5:90;

xdep = 660; % if a phase if reflected or converted at that depth

%%
% rayp = y_get_rayp_directP( evdp, em, dist, np );
% zdt = y_get_raypath_directP( evdp, rayp, em );
% rayp = y_get_rayp_PP( evdp, em, dist, np );
% zdt = y_get_raypath_PP( evdp, rayp, em );
%  rayp = y_get_rayp_PcP( evdp, em, dist, np );
%  zdt = y_get_raypath_PcP( evdp, rayp, em);
% rayp = y_get_rayp_PKPab( evdp, em, dist, np );
% zdt = y_get_raypath_PKPab( evdp, rayp, em);
% rayp = y_get_rayp_PKPbc( evdp, em, dist, np );
% zdt = y_get_raypath_PKPbc( evdp, rayp, em);
% rayp = y_get_rayp_PKPcd( evdp, em, dist, np );
% zdt = y_get_raypath_PKPcd( evdp, rayp, em);
% rayp = y_get_rayp_PKPdf( evdp, em, dist, np );
% zdt = y_get_raypath_PKPdf( evdp, rayp, em);

%  rayp = y_get_rayp_directS( evdp, em, dist, np );
%  zdt = y_get_raypath_directS( evdp, rayp, em );
 %rayp = y_get_rayp_SS( evdp, em, dist, np );
 %zdt = y_get_raypath_SS( evdp, rayp, em );


% rayp = y_get_rayp_SKS( evdp, em, dist, np );
% zdt = y_get_raypath_SKS( evdp, rayp, em);
% rayp = y_get_rayp_SKKS( evdp, em, dist, np );
% zdt = y_get_raypath_SKKS( evdp, rayp, em);
% rayp = y_get_rayp_SP( evdp, em, dist, np ); % multi-pathing, might have some problem
% zdt = y_get_raypath_SP( evdp, rayp, em );

 raypxp = y_get_rayp_PxP( evdp, em, dist, np, xdep );
 zdtpxp = y_get_raypath_PxP( evdp, raypxp, em, xdep );
 
 
 raysxs = y_get_rayp_SxS( evdp, em, dist, np, xdep );
 zdtsxs = y_get_raypath_SxS( evdp, raysxs, em, xdep );
 
 
 
 raysxp = y_get_rayp_SxxP( evdp, em, dist, np, xdep );
 zdtsxp = y_get_raypath_SxxP( evdp, raysxp, em, xdep );
 
figure(1);
hold on;
set(gcf,'color','white');
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position',  [100, 100, 1000, 600])
for iray=1:3
    clear zdt
    if iray==1
        zdt=zdtpxp;
        col=dcol{6};
    elseif iray==2
        zdt=zdtsxs;
        col=dcol{8};
    else
        zdt=zdtsxp;
        col=dcol{7};
    end

  for i = 1:length(zdt)
    for j = 1:length(zdt(i).part)
        zdt(i).part(j).xx = zdt(i).part(j).rr.*sin(zdt(i).part(j).theta+angleoff);
        zdt(i).part(j).yy = zdt(i).part(j).rr.*cos(zdt(i).part(j).theta+angleoff);
    end
end


%% plot



if iray==1
  % plot the surface
  nt = 500;
  %thetai = reshape(linspace(-pi,pi,nt),[],1);
  thetai = reshape(linspace(-pi/2,pi/2,nt),[],1);

  xxsurf = em.re.*sin(thetai);
  yysurf = em.re.*cos(thetai);
  plot(xxsurf,yysurf,'k-','linewidth',1);


% mark angles
dr = em.re/50;
for i = 1:length(sangle)
    ind = find((sangle(i)-mangle)==0);
    if isempty(ind)
        xxs1 = em.re.*sin(sangle(i)+angleoff);
        yys1 = em.re.*cos(sangle(i)+angleoff);
        xxs2 = (em.re+dr).*sin(sangle(i)+angleoff);
        yys2 = (em.re+dr).*cos(sangle(i)+angleoff);
        plot([xxs1 xxs2], [yys1 yys2], 'k-');
    else
        xxs1 = em.re.*sin(sangle(i)+angleoff);
        yys1 = em.re.*cos(sangle(i)+angleoff);
        xxs2 = (em.re+3/2*dr).*sin(sangle(i)+angleoff);
        yys2 = (em.re+3/2*dr).*cos(sangle(i)+angleoff);
        xxs3 = (em.re+5*dr).*sin(sangle(i)+angleoff);
        yys3 = (em.re+5*dr).*cos(sangle(i)+angleoff);
        text(xxs3,yys3,[num2str(sangle(i)*180/pi,'%.0f'),'^o'],...
            'rotation',-(sangle(i)+angleoff)*180/pi,'HorizontalAlignment','center',...
            'fontsize',18);
        plot([xxs1 xxs2], [yys1 yys2], 'k-','linewidth',2);
    end
end

% plot the center
plot(0,0,'k+','linewidth',1);

% plot CMB and IOB
xxcmb = (em.re-em.z_cmb).*sin(thetai);
yycmb = (em.re-em.z_cmb).*cos(thetai);
xxiob = (em.re-em.z_iob).*sin(thetai);
yyiob = (em.re-em.z_iob).*cos(thetai);
% fill the outer core
patch([xxcmb;flipud(xxiob)],[yycmb;flipud(yyiob)],[0.95 0.95 0.95],'edgecolor','none');
plot(xxcmb,yycmb,'k-','linewidth',1);
plot(xxiob,yyiob,'k-','linewidth',1);


%%%plot horizontal line
xxsurf = (em.re).*sin(thetai);
yysurf = (em.re).*cos(thetai);
plot([xxsurf(1) xxsurf(end)], [yysurf(1) yysurf(end)],'k-','linewidth',1);


% plot the transition zone
[c,ind1] = min(abs(em.z-410));
[c,ind2] = min(abs(em.z-660));

xxt1 = (em.re-em.z(ind1)).*sin(thetai);
yyt1 = (em.re-em.z(ind1)).*cos(thetai);
xxt2 = (em.re-em.z(ind2)).*sin(thetai);
yyt2 = (em.re-em.z(ind2)).*cos(thetai);
patch([xxt1;flipud(xxt2)],[yyt1;flipud(yyt2)],[0.6 0.6 0.6],'edgecolor','none');
plot(xxt1,yyt1,'k--');
plot(xxt2,yyt2,'k--');



end
% plot the ray path

    
  for i = 1:length(zdt)
    for j = 1:length(zdt(i).part)
        if strcmpi(zdt(i).part(j).ps,'P')
            color = 'b';
        elseif strcmpi(zdt(i).part(j).ps,'S')
            color = 'r';
        else
            fprintf('Please check P or S!\n');
            return;
        end
            
        plot(zdt(i).part(j).xx,zdt(i).part(j).yy,'color',col,'LineWidth',1);
    end
    % plot receiver
    dz = 0.7*em.re/30;
    dtheta = dz/sqrt(3)/em.re;
    p1 = [(zdt(i).part(end).rr(end)+dz)*sin(zdt(i).part(end).theta(end)+angleoff) (zdt(i).part(end).rr(end)+dz)*cos(zdt(i).part(end).theta(end)+angleoff)];
    p2 = [zdt(i).part(end).rr(end)*sin(zdt(i).part(end).theta(end)+angleoff-dtheta) zdt(i).part(end).rr(end)*cos(zdt(i).part(end).theta(end)+angleoff-dtheta)];
    p3 = [zdt(i).part(end).rr(end)*sin(zdt(i).part(end).theta(end)+angleoff+dtheta) zdt(i).part(end).rr(end)*cos(zdt(i).part(end).theta(end)+angleoff+dtheta)];
    px = [p1(1);p2(1);p3(1);p1(1)];
    py = [p1(2);p2(2);p3(2);p1(2)];
    % patch(px,py,'k-');
  
    
    scatter(px(1),py(1),100.0,'^','MarkerEdgeColor',[17 17 17]/255,'linewidth',1)
  end    
end

 % plot source

 scatter(zdt(1).part(1).xx(1),zdt(1).part(1).yy(1),100,'filled','MarkerFaceColor','black');

set(gca,'Ydir','normal');
doff = 1000;
axis([min(xxsurf)-doff max(xxsurf)+doff min(yysurf)-doff max(yysurf)+doff])
axis equal
axis off



%set(gcf,'color','white');
end

