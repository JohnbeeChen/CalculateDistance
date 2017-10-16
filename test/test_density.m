% close all;
clear;
load merged_centroids.mat

points = all_centroids(:,1:2);
X = points;
radius = 30;
tem_max = max(points(:)) + 50;
tem_min = min(points(:)) - 50;


bound = [tem_min tem_min;tem_max,tem_max];
[xl,yl,lamhat] = csintkern(points,bound,radius);
pixel_size = (tem_max - tem_min)/(length(lamhat)-1);

level = 8;
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
region_max = imregionalmax(lamhat);
% figure;
% imshow(flipud(region_max));
% sum(re_max(:))
[idy,idx] = find(region_max == 1);
thres = 30;
point_set = tem_min - pixel_size + pixel_size*[idx,idy];
tem = PointsMerge(point_set,thres);
figure;
plot(points(:,1),points(:,2),'r*');
hold on
plot(tem(:,1),tem(:,2),'kx');
hold on
circle(tem,15);
hold off

cluster_num = size(tem,1);
opts = statset('Display','final');
[idx,C,~] = kmeans(X,[],'Options',opts,'OnlinePhase','on','Start',tem);
figure;
for ii  = 1:cluster_num
    hold on
    plot(X(idx==ii,1),X(idx==ii,2),'*','MarkerSize',12);
end
hold on
plot(C(:,1),C(:,2),'kx','MarkerSize',12,'LineWidth',2);
hold on
circle(C(:,1:2),15);
hold off
grid minor;
title(['clusters number: ',num2str(cluster_num)]);