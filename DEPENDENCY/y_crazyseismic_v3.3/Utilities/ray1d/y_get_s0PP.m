function  [rayp, taup1, dtaup1]= y_get_s0PP (evdp, np, em)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_cmb - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, sp_fine );

ztmp = max( em.z_660 , evdp) + 10^-6 ; 
[pmax,iflag] =  interp1db ( ztmp, em.z, sp_fine );

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  em.z, sp_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pj, em.z, sp_fine);
    [rtmp2, dtmp2]= tau (0.0,evdp,pj, em.z, sp_fine);
    [rtmp3, dtmp3]= tau (0.0,evdp,pj, em.z, ss_fine);
    taup1(j) = 4* rtmp1 + 4* rtmp2 + rtmp3;
    dtaup1(j) = 4* dtmp1 + 4* dtmp2 + dtmp3;
end

end
