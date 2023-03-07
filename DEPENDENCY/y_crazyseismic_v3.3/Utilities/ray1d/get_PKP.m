% function  [rayp, taup1, dtaup1]= get_PKP (zdep, np, em)
function  [rayp, taup1, dtaup1, pbc, xbc, pab, xab]= get_PKP (zdep, np, em)
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

ztmp = z_cmb; 
[pmin,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
if (iflag ~=1) ,
    disp( 'get_PKP: kxkj3x22 e2sdfafvadf ');
    pause;
end

pmin = pmin -1; 

ztmp = z_iob - .1;
[pmax,iflag] =  interp1db ( ztmp, z_fine, sp_fine );
if (iflag ~=1) ,
    disp( 'get_PKP: kxkj3x22 e2sdfafvadf ');
    pause;
end

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zmin = z_cmb + 100; 
    zt= wise_turn_v2 (pj, zmin,  z_fine, sp_fine);
    if ( zt < zdep ) ,
        disp( 'here is a problem in get_PKP ') ;
        pause;
    end
    zt = zt - .001;
    [rtmp1, dtmp1]=  tau (zdep, zt ,pj, z_fine, sp_fine);
    [rtmp2, dtmp2]= tau ( 0.0,zdep,pj, z_fine, sp_fine);
    taup1(j) = 2* rtmp1 + rtmp2;
    dtaup1(j) = 2* dtmp1 + dtmp2;
end

% extract -ab & -bc branches 
[dmin, imin] = min( dtaup1); 
pbc = rayp(1:imin); 
xbc = dtaup1(1:imin);
pab = rayp(imin:np);
xab = dtaup1(imin:np); 
