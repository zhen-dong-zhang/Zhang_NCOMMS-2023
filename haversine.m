function [d,azi]=haversine(lat,long)
% HAVERSINE     Computes the  haversine (great circle) distance in metres
% between successive points on the surface of the Earth. These points are
% specified as vectors of latitudes and longitudes.
%
%This was written to compute the distance between
%
%   Examples
%       haversine([53.463056 53.483056],[-2.291389 -2.200278]) returns
%       6.4270e+03
%
%   Inputs
%       Two vectors of latitudes and longitudes expressed in decimal
%       degrees. Each vector must contain at least two elements.
%
%   Notes
%       This function was written to process data imported from a GPS
%       logger used to record mountain bike journeys around a course.
% if long> 180.0
%     long=long-360.0
% end
% 
% long

long=deg2rad(long);
lat=deg2rad(lat);
dlat=diff(lat);
dlong=diff(long);
a=sin(dlat/2).^2+cos(lat(1:end-1)).*cos(lat(2:end)).*sin(dlong/2).^2;
c=2*atan2(sqrt(a),sqrt(1-a));
R=6371; %in Kmetres
d=180.0*c/pi;
%d=c;
% 180.0*(dis_sort(ist)/6371.0)/pi

vecn = [long(1), 90] - [long(1), lat(1)];
vecs = [long(2), lat(2)] - [long(1), lat(1)];
CosTheta = max(min(dot(vecn,vecs)/(norm(vecn)*norm(vecs)),1),-1);
if (long(2) > long(1))
   azi  = real(acosd(CosTheta));
else
    azi  = 360.0-real(acosd(CosTheta));
end



