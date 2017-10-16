function varargout = PointsMerge(pointSet,thre_number)
% merge the points which distance between the any two points in @pointSet 
% less than or equal to  @threDis

thre = thre_number;
point_set = pointSet;
num = size(point_set,1);
if thre_number > num
   disp('the cluster number is more than the points number');
   return;
end
while 1
    if num <= thre
        break;
    else
        [idx,~] = FindNearestPoints(point_set);
        p1 = point_set(idx(1),:);
        p2 = point_set(idx(2),:);
        new_point = (p1 + p2)/2;
        point_set(idx(1),:) = new_point;
        point_set(idx(2),:) = [];
        num = size(point_set,1);
    end
end
varargout{1} = point_set;

end