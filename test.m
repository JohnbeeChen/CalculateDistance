%employ kmeans to cluster the RNN acceptor

% close all;
load centroids.mat

cluster_num = 24;
pixe_size = 32.5;
X = centroids(:,1:2);
% figure;
% plot(X(:,1),X(:,2),'k*','MarkerSize',5);
opts = statset('Display','final');
[idx,C,sumd] = kmeans(X,cluster_num,'Replicate',10,'Options',opts);
[~,min_distance] = FindNearestPoints(C);
figure;
for ii  = 1:cluster_num
    hold on
    plot(X(idx==ii,1),X(idx==ii,2),'*','MarkerSize',12);
    hold on
    plot(C(ii,1),C(ii,2),'kx','MarkerSize',12,'LineWidth',2);
    hold on
    circle(C(ii,1),C(ii,2),15);
end

hold off
title(['clusters number: ',num2str(cluster_num),',minimum distance: ',num2str(min_distance)]);
grid minor
axis equal


function [] = circle(x,y,r)
rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1]);
end