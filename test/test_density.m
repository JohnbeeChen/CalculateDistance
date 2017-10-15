% close all;
clear;
load all_centroids.mat

points = all_centroids(:,1:2);
radius = 30;
tem_max = max(points(:)) + 50;
tem_min = min(points(:)) - 50;
bound = [tem_min tem_min;tem_max,tem_max];
[xl,yl,lamhat] = csintkern(points,bound,radius);
level = 6;
figure;
subplot(1,2,1);
c=contour(xl,yl,lamhat,level);
hold on;
plot(points(:,1),points(:,2),'rX');
hold on 
grid minor;
axis equal;
subplot(1,2,2);
surf(lamhat);

