
function  [rayp1, taup1, dtaup1, raypd, taupd, dtaupd, raypu,taupu,dtaupu, rayp2, taup2, dtaup2]= get_PKxKP_mig (zdep, xdep, np, em)
% 
%
% [rayp1, taup1, dtaup1, raypd, taupd, dtaupd, raypu,taupu,dtaupu]=
% get_PKxKP (zdep, xdep, np, em)
% 
% calculate t curves between zdep & xdep and 
% xdep to earth surface 
% 
% !//     'pmin' is ~ 0, i.e., straight through the center of the Earth
% !// 	'pmax' is slightly > p_iob
% real zdep
% real rayp(*), taup1(*), dtaup1(*)
% integer np ,iflag
% real pj , ztmp, ztmp2 ,pmin, pmax , zt

z_iob = em.z_iob;
z_cmb = em.z_cmb; 

z_fine = em.z; 
re = em.re; 
sp_fine = (re - z_fine)./em.vp; 

ztmp = z_iob + xdep + 1.; 

[pmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
if (iflag ~=1) ,
    disp( 'get_PKxKP: kxkj3x22 e2sdfafvadf ');
    pause;
end

pmin = 10; 

% pmin = pmin 
%% source side, downgoing 
disp('source side'); 
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp1(j) = pj;
     zt = z_iob + xdep -.1; 
    [rtmp1, dtmp1]=  tau (zdep, zt ,pj, z_fine, sp_fine);
    taup1(j) = rtmp1 ;
    dtaup1(j) = dtmp1 ;
end

%% source side, turning 
disp('source side'); 
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp3(j) = pj;
%      zt = z_iob + xdep -.1;
    zmin = z_cmb + 100;
         zt= wise_turn_v2 (pj, zmin,  z_fine, sp_fine);
         zscatt = z_iob + xdep; 
    [rtmp1, dtmp1]=  tau (zscatt, zt -.1,pj, z_fine, sp_fine);
    [rtmp2, dtmp2]=  tau (zdep, z_iob+xdep,pj, z_fine, sp_fine);
    taup3(j) = 2*rtmp1 + rtmp2;
    dtaup3(j) =2* dtmp1 + dtmp2;
end

% rayp1 = [rayp1 fliplr(rayp3)];
% taup1 = [taup1 fliplr(taup3)];
% dtaup1 = [dtaup1 fliplr(dtaup3)];

disp('receiver side, upgoing'); 
%% receiver side, upgoing
pmin = 10; 
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    raypu(j) = pj;
     zt = z_iob + xdep - .1;
    [rtmp1, dtmp1]=  tau (0, zt ,pj, z_fine, sp_fine);
    taupu(j) = rtmp1 ;
    dtaupu(j) = dtmp1 ;
end

%% receiver side, downgoing
disp('receiver side, downgoing'); 
pmin = 10;
dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    raypd(j) = pj;
    zmin = z_cmb + 100;
    zt= wise_turn_v2 (pj, zmin,  z_fine, sp_fine);
    if ( zt < zdep ) ,
        disp( 'here is a problem in get_PKxKP ') ;
        pause;
    end
    zt = zt - .1; 
     ztmp = z_iob + xdep; 
    [rtmp1, dtmp1]=  tau (ztmp, zt ,pj, z_fine, sp_fine);
    [rtmp2, dtmp2]= tau ( 0.0, zt,pj, z_fine, sp_fine);
    taupd(j) = 2* rtmp1 + rtmp2;
    dtaupd(j) = 2* dtmp1 + dtmp2;
end
% 
% %% combine 
% dtaup2 = [dtaupu fliplr(dtaupd) ]; 
% taup2 = [taupu fliplr(taupd) ]; 
% rayp2 = [raypu fliplr(raypd) ]; 
dtaup2 = dtaupu;% fliplr(dtaupd) ]; 
taup2 = taupu ;% fliplr(taupd) ]; 
rayp2 = raypu ;%fliplr(raypd) ]; 
% end subroutine get_PKIKP
