
% close all;
prompt={'clusters number:'};
defaults={num2str(4)};
info = inputdlg(prompt, 'Input for process...!', 1, defaults);
if ~isempty(info)
    cluster_num = str2double(info(1));
else
   return; 
end
load all_centroids.mat

% cluster_num = 10;
X = all_centroids(:,1:2);
% figure;
% plot(X(:,1),X(:,2),'k*','MarkerSize',5);
opts = statset('Display','final');
[idx,C,sumd] = kmeans(X,cluster_num,'Replicate',10,'Options',opts);
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
grid minor
axis equal
save('cluster_centroieds.mat','C');
