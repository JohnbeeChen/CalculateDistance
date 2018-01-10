function varargout = clustering(varargin)


X = varargin{1};
star_centroid  = varargin{2};
name = varargin{3};

opts = statset('Display','final');
[idx,C,~] = kmeans(X,[],'Options',opts,'Start',star_centroid);
% [~,min_distance] = FindNearestPoints(C);
cluster_num = size(C,1);

figure;
for ii  = 1:cluster_num
    hold on
    plot(X(idx==ii,1),X(idx==ii,2),'.','MarkerSize',13);
    tem_point = X(idx==ii,1:2);
    R(ii,:) = FindLeastCircle(tem_point);
    hold on
    circle(R(ii,1:2),R(ii,3));
end
radiuses = R(:,3);
positive_idx = radiuses ~= 0;
radiuses = radiuses(positive_idx);
area = pi*radiuses.^2;
ave_area = mean(area);
ave_radiuses = mean(radiuses);
title(['circles average radius: ',num2str(ave_radiuses),';cluster number:',num2str(cluster_num)]);
if ~isempty(name)
    print(gcf,'-dpng',[name,'_leastcircle.png']);
end
figure;
for ii = 1:cluster_num
    hold on
    plot(X(idx==ii,1),X(idx==ii,2),'.','MarkerSize',13);
end
% hold on
% plot(C(:,1),C(:,2),'kx','MarkerSize',12,'LineWidth',2);
hold on
circle(C(:,1:2),15);
hold off
% title(['clusters number: ',num2str(cluster_num),',minimum distance: ',num2str(min_distance)]);
grid minor;
if ~isempty(name)
    print(gcf,'-dpng',[name,'_cluster.png']);
end

save('cluster_centroieds.mat','C');

varargout{1} = C;
varargout{2} = idx;