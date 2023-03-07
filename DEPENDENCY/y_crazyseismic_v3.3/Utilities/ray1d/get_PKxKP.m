function  [rayp, taup1, dtaup1]= get_PKxKP (zdep, xdep, np, em)
% !//     'pmin' is ~ 0, i.e., straight through the center of the Earth
% !// 	'pmax' is slightly > p_iob
% real zdep
% real rayp(*), taup1(*), dtaup1(*)
% integer np ,iflag
% real pj , ztmp, ztmp2 ,pmin, pmax , zt

z_iob = em.z_iob;
z_fine = em.z; 
re = em.re; 
sp_fine = (re - z_fine)./em.vp; 

ztmp = xdep + z_iob;
[pmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
if (iflag ~=1) ,
    disp( 'get_PKxKP: kxkj3x22 e2sdfafvadf ');
    pause;
end

pmin = 0;

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    [rtmp1, dtmp1]=  tau (zdep, ztmp-1 ,pj, z_fine, sp_fine);
    [rtmp2, dtmp2]= tau ( 0.0,zdep,pj, z_fine, sp_fine);
    taup1(j) = 2* rtmp1 + rtmp2;
    dtaup1(j) = 2* dtmp1 + dtmp2;
end
