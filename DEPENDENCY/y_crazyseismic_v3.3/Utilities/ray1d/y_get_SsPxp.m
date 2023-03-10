function [rayp1, taup1, dtaup1]= y_get_SsPxp (evdp, np, em, xdep)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_cmb - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );
ztmp = max( em.z_660 , evdp) + 10^-6; 
[pmax1,iflag] =  interp1db ( ztmp, em.z, ss_fine );
ztmp = xdep; 
[pmax2,iflag] =  interp1db ( ztmp, em.z, sp_fine );
pmax = min([pmax1,pmax2]);

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp1(j) = pj; 
    ztS= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  em.z, ss_fine);
    ztS = ztS - 0.5*10^-6;
    ztP= xdep;
    [rtmp1, dtmp1]= tau (evdp, ztS ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau ( 0.0, ztS,pj, em.z, ss_fine);
    [rtmp3, dtmp3]= tau ( 0.0, ztP,pj, em.z, sp_fine);
    taup1(j) = real(rtmp1 + rtmp2 + 2*rtmp3);
    dtaup1(j) = real(dtmp1 + dtmp2 + 2*dtmp3);
end

end