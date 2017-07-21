rng default
load kmeansdata.mat
size(X)
idx3 = kmeans(X,3,'Distance','cityblock');
figure 
[silh3,h] = silhouette(X,idx3,'cityblock');
h = gca;
h.Children.EdgeColor = [0.8,0.8,1];
xlabel 'Silhouette Value';
ylabel 'Cluster';