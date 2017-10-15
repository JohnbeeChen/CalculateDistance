function varargout = channel_assign(varargin)
% assign the input points to each channel 

centroid = varargin{1};
cluster_centroid = varargin{2};

centroid_num = size(centroid,1);
n = size(cluster_centroid,1);

tem_x = [0,0;cluster_centroid];
for ii = 1:centroid_num
    tem_x(1,:) = centroid(ii,:);
    
    dist = pdist(tem_x);
    dist = dist(1:n);
    idx = find(min(dist) == dist);
    cluster_idx(ii) = idx(1);
end
t = cluster_idx';
varargout{1} = cluster_idx';

end