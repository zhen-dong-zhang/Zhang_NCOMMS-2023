function  [rayp, taup1, dtaup1]= y_get_SxxP (evdp, np, em, xdep)

em.vs(find(em.vs==0))=1e-9;
sp_fine = (em.re - em.z)./em.vp; 
ss_fine = (em.re - em.z)./em.vs; 

% ztmp = em.z_cmb - 10^-6; 
% [pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );
% 
% ztmp = max( [em.z_660 , evdp, xdep]) + 10^-6 ; 
% [pmax,iflag] =  interp1db ( ztmp, em.z, ss_fine );

ztmp = em.z_cmb - 10^-6; 
[pmin,iflag] =  interp1db ( ztmp, em.z, ss_fine );
ztmp = max( [em.z_660 , evdp,xdep]) + 10^-6 ; 
[pmax,iflag] =  interp1db ( ztmp, em.z, ss_fine );


dp = ( pmax- pmin) /(np -1);
for j =1: np-2
    pj = (j-1)* dp + pmin;
    rayp(j) = pj;
    zt_s= wise_turn_v3 (pj, [xdep em.z_cmb],  em.z, ss_fine);
    zt_s = zt_s - 0.5*10^-6;
    zt_p= wise_turn_v3 (pj, [xdep em.z_cmb],  em.z, sp_fine);
    zt_p = zt_p - 0.5*10^-6;
   
    if zt_p >0
       [rtmp1, dtmp1]=  tau (evdp, zt_s ,pj, em.z, ss_fine);
       [rtmp2, dtmp2]= tau ( xdep, zt_s,pj, em.z, ss_fine);
       [rtmp3, dtmp3]= tau ( xdep, zt_p,pj, em.z, sp_fine);
       [rtmp4, dtmp4]= tau ( 0.0, zt_p,pj, em.z, sp_fine);
    
       taup1(j) = rtmp1 + rtmp2 + rtmp3 + rtmp4;
       dtaup1(j) = dtmp1 + dtmp2 + dtmp3 + dtmp4;
    else
       taup1(j) = NaN;
       dtaup1(j) = NaN;
       
    end
    
end

end