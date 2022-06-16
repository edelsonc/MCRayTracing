classdef OpaquePanel1D < Panel1D
    % Very simple subclass of the Panel1D class. Used for opaque planes in 2D
    % simulations.
    methods
        function obj = OpaquePanel1D(start, stop)
            obj@Panel1D(start, stop)
        end
        function [ray, ray_origin] =  get_propogated_ray(obj, ray, intersection)
            ray = nan;
            ray_origin = nan; 
        end
    end
end
