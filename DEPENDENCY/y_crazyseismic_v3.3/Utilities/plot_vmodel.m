function [ h ] = plot_vmodel( varargin )
%PLOT_VMODEL Summary of this function goes here
%   Detailed explanation goes here

% example
% h = plot_vmodel(model,modeltype,lthtype,maxdepth)

% plot 1D velocity model
% tic
model = [6.3 2.7 40 0.25;
         8.1 3.3 0 0.25];
modeltype = '3'; % 3 for vp rho r/2 poi; for others see icmod from reflective code (Kennett)
lthtype = '2'; % 1 for layer thickness; 2 for depth to bottom of layer
maxdepth = 100;
if nargin >= 1 
    if ~isempty(varargin{1})
        model = varargin{1};
    end
end
if nargin >= 2
    if ~isempty(varargin{2})
        modeltype = varargin{2};
    end
end
if nargin >= 3
    if ~isempty(varargin{3})
        lthtype = varargin{3};
    end
end
if nargin >= 4
    if ~isempty(varargin{4})
        maxdepth = varargin{4};
    end
end

switch modeltype
    case {'1','2'}
        vp = model(:,1);        vs = model(:,2);        depth = model(:,4);     pois = 0.25*ones(size(model(:,1)));
    case '3'
        vp = model(:,1);        pois = model(:,4);        vp2vs = sqrt(1+(1-2*pois).^(-1));
        vs = vp./vp2vs;        depth = model(:,3);
    case '4'
        vs = model(:,1);        pois = model(:,4);        vp2vs = sqrt(1+(1-2*pois).^(-1));
        vp = vs.*vp2vs;        depth = model(:,3);
    case '5'
        vp = model(:,1);        vs = vp/sqrt(3);        depth = model(:,2);     pois = 0.25*ones(size(model(:,1)));
end

if strcmpi(lthtype,'1')
    depth = cumsum(depth);
    depth(end) = 0;
end

n = size(model,1);

depth_new = zeros(size(2*n,1));
vp_new = zeros(size(2*n,1));
vs_new = zeros(size(2*n,1));
depth_new(2:2:2*n-2) = depth(1:n-1);
depth_new(3:2:2*n-1) = depth(1:n-1);
depth_new(2*n) = max(maxdepth,depth(n-1));
vp_new(1:2:2*n-1) = vp(1:n);
vp_new(2:2:2*n) = vp(1:n);
vs_new(1:2:2*n-1) = vs(1:n);
vs_new(2:2:2*n) = vs(1:n);
% vp_new(1) = vp(1);  vp_new(2:n+1) = vp;
% vs_new(1) = vs(1);  vs_new(2:n+1) = vs;
% depth_new(1) = 0;   depth_new(2:n) = depth(1:n-1);  
% if maxdepth < depth_new(n)
%     depth_new(n+1) = depth_new(n);
% else
%     depth_new(n+1) = maxdepth;
% end
% toc
% tic
% h(1) = stairs(vp_new,depth_new,'b');    hold on ;
% h(2) = stairs(vs_new,depth_new,'r--');    hold on;
h(1) = plot(vp_new,depth_new,'b');    hold on ;
h(2) = plot(vs_new,depth_new,'r--');    hold on
% toc
% legend({'P velocity', 'S velocity'});
set(gca,'Ydir','reverse');
% ylim([0,maxdepth]);
% ylabel('Depth (km)');
% xlabel('Velocity (km/s)');
% title('Velocity Model','Fontsize',16);

end
