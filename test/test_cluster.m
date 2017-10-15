% close all;
load all_centroids.mat

centroids_num = size(all_centroids,1);
X = all_centroids(:,1:2);

eva = evalclusters(X,'kmeans','gap');

% opts = statset('Display','final');
% for num = 2:(centroids_num-3)
%     cluster_num = num;
%     [idx,C,sumd] = kmeans(X,cluster_num,'Replicate',10,'Options',opts);
%     [~,min_distance] = FindNearestPoints(C);
%     figure;
%     for ii  = 1:cluster_num
%         hold on
%         plot(X(idx==ii,1),X(idx==ii,2),'*','MarkerSize',12);
%     end
%     hold on
%     plot(C(:,1),C(:,2),'kx','MarkerSize',12,'LineWidth',2);
%     hold on
%     circle(C(:,1:2),15);
%     hold off
%     title(['clusters number: ',num2str(cluster_num),',minimum distance: ',num2str(min_distance)]);
%     grid minor
%     axis equal
% end
