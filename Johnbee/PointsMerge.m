function varargout = PointsMerge(pointSet,threDis)
% merge the points which distance between the any two points in @pointSet 
% less than or equal to  @threDis

thre = threDis;
point_set = pointSet;

while 1
    [idx,nearest_dis] = FindNearestPoints(point_set);
    if nearest_dis > thre
        break;
    else
        p1 = point_set(idx(1),:);
        p2 = point_set(idx(2),:);
        new_point = (p1 + p2)/2;
        point_set(idx(1),:) = new_point;
        point_set(idx(2),:) = [];
    end
end
varargout{1} = point_set;

end