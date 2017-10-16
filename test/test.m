
load all_centroids.mat
X = all_centroids(:,1:2);
% 
% opts = statset('Display','off');
% gm = gmdistribution.fit(X,2,'Options',opts);
% P6 = figure;clf
% scatter(X(:,1),X(:,2),10,'ro');
% hold on
% ezcontour(@(x,y) pdf(gm,[x,y]),[-15,15],[-15,19]);
% hold off
% 
% P7 = figure; clf
% scatter(X(:,1),X(:,2),10,'ro');
% hold on
% ezsurf(@(x,y) pdf(gm,[x,y]),[-15,15],[-15,19]);
% hold off
% view(33,24);

opts = statset('Display','final');
% stream = RandStream('mcg16807','Seed',1);
% RandStream.setGlobalStream(stream);
cluster_num = 34;

[cidx,ctrs] = kmeans(X,cluster_num,'Replicates',5,'Options',opts);

figure;
for ii  = 1:cluster_num
    hold on
    plot(X(cidx==ii,1),X(cidx==ii,2),'*','MarkerSize',12);
end
hold on
plot(ctrs(:,1),ctrs(:,2),'kx','MarkerSize',12,'LineWidth',2);
hold on
circle(ctrs(:,1:2),15);
hold off
grid minor