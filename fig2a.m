%%plot ray path
clear all;
clc;
addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities')
addpath('/Users/zhendongzhang/Desktop/SummerSchool_USTC2020/y_crazyseismic_v3.3/Utilities/ray1d')
addpath('/Users/zhendongzhang/Desktop/Glob_KAUST/plot_frederik')
addpath('/Users/zhendongzhang/Desktop/Glob_KAUST/Geometry_plot')
setenv('IFILES','/Users/zhendongzhang/Desktop/Glob_KAUST/plot_frederik/IFILES');

[dcol,vcol]=define_color(6);
%main
plot_raypath(49.5,112.5)


hl = zeros(5, 1);
hl(1) = plot(NaN,NaN,'v','Color',[17 17 17]/255,'MarkerSize',15,'Linewidth',1.0);
hl(2) = plot(NaN,NaN,'.','Color','black','MarkerSize',35,'Linewidth',1.0);
hl(3) = plot(NaN,NaN,'Color',dcol{8},'Linewidth',1.0);
hl(4) = plot(NaN,NaN,'Color',dcol{7},'Linewidth',1.0);
hl(5) = plot(NaN,NaN,'Color',dcol{6},'Linewidth',1.0);
% legend(hl, 'Stations','Source','P660P','S660S','S660P',...
%     'FontSize',20,'Orientation','horizontal','Position',[0.32 0.2 0.4 0.1]);
% 
% 
% legend boxoff 
% 
% [hh,icons] = legend(hl, 'Station','Earthquake','S660S','S660P','P660P',...
%     'FontSize',18,'Orientation','horizontal','Position',[0.32 0.15 0.4 0.1]);
% 
% legend boxoff 

% icons(7).MarkerSize = 15;
% icons(7).LineWidth = 2.0;
% icons(9).LineWidth = 2.0;
% icons(9).MarkerSize = 40;
% icons(10).LineWidth = 3.0;
% icons(12).LineWidth = 3.0;
% icons(14).LineWidth = 3.0;
set(gcf, 'Position',  [100, 100, 320, 200])
% savefig('test.fig')