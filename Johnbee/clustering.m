function varargout = clustering(varargin)

% load all_centroids.mat
% 
% % cluster_num = 10;
% X = all_centroids(:,1:2);
X = varargin{1};
cluster_num  = varargin{2};
% figure;
% plot(X(:,1),X(:,2),'k*','MarkerSize',5);
opts = statset('Display','final');
[idx,C,~] = kmeans(X,cluster_num,'Replicate',10,'Options',opts);
[~,min_distance] = FindNearestPoints(C);
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
title(['clusters number: ',num2str(cluster_num),',minimum distance: ',num2str(min_distance)]);
grid minor;
save('cluster_centroieds.mat','C');

varargout{1} = C;