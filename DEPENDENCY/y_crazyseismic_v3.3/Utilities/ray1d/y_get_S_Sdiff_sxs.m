function  [rayp, taup1, dtaup1]= y_get_S_Sdiff_sxs (evdp, np, em, xdep)

mdist = 180*pi/180; % maximum distance for diffraction wave

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

ztmp = em.z_cmb - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );

ztmp = max( em.z_660 , evdp) + 10^-6; 
[pmax,iflag] =  interp1db ( ztmp, em.z, ss_fine );

dp = ( pmax- pmin) /(np -1);
for j =1: np
    pj = pmax - (j-1)*dp;
%     pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt= wise_turn_v3 (pj, [em.z_660 em.z_cmb],  em.z, ss_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pj, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,zt,pj, em.z, ss_fine);
    [rtmp3, dtmp3]= tau (0.0,xdep,pj, em.z, ss_fine);
    taup1(j) = rtmp1 + rtmp2 + 2*rtmp3;
    dtaup1(j) = dtmp1 + dtmp2 + 2*dtmp3;
end

% add diffrantion part
ddist = linspace(dtaup1(np),mdist,np+1) - dtaup1(np);
for j = np+1:2*np    
    zt= wise_turn_v3 (pmin, [em.z_660 em.z_cmb],  em.z, ss_fine);
    zt = zt - 0.5*10^-6;
    [rtmp1, dtmp1]= tau (evdp, zt ,pmin, em.z, ss_fine);
    [rtmp2, dtmp2]= tau (0.0,zt,pmin, em.z, ss_fine);
    [rtmp3, dtmp3]= tau (0.0,xdep,pj, em.z, ss_fine);

    dtaup1(j) = dtmp1 + dtmp2 + 2*dtmp3 + ddist(j-np+1);
    taup1(j) = rtmp1 + rtmp2 + 2*rtmp3 + 0;
    rayp(j) = pmin;
end

end
