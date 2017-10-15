function [X,Y,Z]=csintkern(x,bound,r)
% CSINTKERN Kernel method for estimating intensity of spatial point pattern.
%
%   [X,Y,Z] = CSINTKERN(EVENTS,REGION,H)
%
%   This function implements the kernel method for estimating the
%   intensity for a spatial point pattern. It uses the quartic
%   kernel. Edge effects are ignored. The output X, Y, Z can be
%   used in the MATLAB functions MESH or SURF to plot. Z contains
%   the value of the intensity at points given in X and Y. 
%
%   EVENTS contains the locations for the spatial events. This is
%   an n x 2 matrix. The first column contains the x locations and
%   the second column contains the y locations.
%   REGION is a matrix of x and y locations for the vertices of the
%   study region. The first column contains the x locations and the
%   second column contains the y locations.
%   H is the window width for the kernel.

%   W. L. and A. R. Martinez, 9/15/01
%   Computational Statistics Toolbox

[n,d]=size(x);

% Get the ranges for x and y
% Get a rectangular bounding region.
minx=min(bound(:,2));
maxx=max(bound(:,2));
miny=min(bound(:,1));
maxy=max(bound(:,1));
% Get 100 linearly spaced points
xd = linspace(minx,maxx,100);
yd = linspace(miny,maxy,100);
[X,Y]=meshgrid(xd,yd);
%xc=X(:);   %put into col vectors
%yc=Y(:);
st = [X(:), Y(:)];
ns = length(st(:,1));
xt = [[0,0] ; x];
z=zeros(size(X(:)));	
H = waitbar(0,'Please wait ...');
for i=1:ns	% note that const done at end
	waitbar(i/ns,H)
	% for each point location, s, find the distances
	% that are less than h.
	xt(1,:) = st(i,:);
	% find the distances. First n points in dist
	% are the distances between the point s and the
	% n event locations.
	dist = pdist(xt);
	ind = find(dist(1:n) <= r);
	t = (1 - dist(ind).^2/r^2).^2;
	z(i) = sum(t);
end
close(H)
z = z*3/(pi*r);

[mm,nn]=size(X);
Z=reshape(z,mm,nn);

