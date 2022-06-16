classdef Screen1D < Panel1D
    properties
        intersections
    end
    methods
        function obj = Screen1D(start, stop)
            obj@Panel1D(start, stop)
            obj.intersections = [];
        end
        function [ray, ray_origin] = get_propogated_ray(obj, ray, intersection)
            obj.intersections = cat(1, obj.intersections, intersection);
            ray = nan;
            ray_origin = nan;
        end
    end
end
