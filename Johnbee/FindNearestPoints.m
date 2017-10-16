function varargout = FindNearestPoints(pointSet)
% @pointSet must be row vectors

point_set = pointSet;
point_num = size(point_set,1);

min_distance = norm(point_set);%initial the minmum distance

for ii = 1 : point_num
    p1 = point_set(ii,:);
    for jj = 1:point_num
        if ii~=jj           
            p2 = point_set(jj,:);
            tem_distance = norm(p1 - p2);
            if tem_distance < min_distance
               min_distance = tem_distance; 
%                ref_points(1,:) = p1;
%                ref_points(2,:) = p2;
               idx = [ii,jj];
            end
        end
    end
end
varargout{1} = idx;
varargout{2} = min_distance;