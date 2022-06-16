classdef Diode1D < Panel1D
    % Subclass of Panel1D used for simulating a diode in an optics system. Has
    % and photosensitive side which increaments a ray counter everytime an
    % incident ray intersects with the active side.
    properties
        count
    end
    methods
        function obj = Diode1D(start, stop)
            obj@Panel1D(start, stop);
            obj.count = 0;
        end
        function increase_count(obj)
            obj.count = obj.count + 1;
        end
        function [ray, ray_origin] = get_propogated_ray(obj, ray, intersection)
            % here we compute if the ray hits the active photosensitive side
            % the diode
            if dot(obj.normal, ray) < 0
                obj.increase_count()
            end

            ray = nan;
            ray_origin = nan;
        end
    end
end
