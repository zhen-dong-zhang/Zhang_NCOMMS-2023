clear all;
clc;

addpath('/Users/zhendongzhang/Desktop/Glob_KAUST/plot_frederik')
setenv('IFILES','/Users/zhendongzhang/Desktop/Glob_KAUST/plot_frederik/IFILES');

%%LOAD EQ AND STATIONS
load('EQSYN.mat')
load('STATIONSSYN.mat')
neq  = size(EQSYN,1);
nsta = size(STATIONSSYN,1);

%input for loris1 sub...
N  = 4;
eo = 0;
lon= -75;
lat= 40;
sc=  0;
fax= 1;
opt= 'GJI2011';

%%anamoly
wed1(1) = lon-1;
wed1(2) = lat-20;
wed1(3) = lon-1;
wed1(4) = lat+20;
wed1(5) = lon+1;
wed1(6) = lat+20;
wed1(7) = lon+1;
wed1(8) = lat-20;


for i=1:neq
    vlat_eq(i) = EQSYN(i,1);
    vlon_eq(i) = EQSYN(i,2);
    vmag_eq(i) = EQSYN(i,5);
    vrad_eq(i) = (6371.1-EQSYN(i,3))/6371.1;
end

for i=1:nsta
    vlat_st(i) = STATIONSSYN(i,1);
    vlon_st(i) = STATIONSSYN(i,2);
    vrad_st(i) = (6371.1-0.001*STATIONSSYN(i,3))/6371.1;
end

%define color based on magnitude of eq
[dcol,vcol]=define_color(vmag_eq);

loris_zzd(N,eo,lon,lat,sc,fax,opt,...
    vlon_eq,vlat_eq,vrad_eq,vmag_eq,vcol,dcol,...
    vlon_st,vlat_st,vrad_st,wed1);


axis off