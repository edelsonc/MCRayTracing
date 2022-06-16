classdef ConvergingLens1D < Panel1D
    properties
        focal_length
    end
    methods
        function obj = ConvergingLens1D(start, stop, focal_length)
           assert(focal_length > 0, "`focal_length` must be positive") 

            obj@Panel1D(start, stop);
            obj.focal_length = focal_length;
        end
        function [ray, ray_origin] = get_propogated_ray(obj, ray, intersection)
            % I've decided I'm going to brute force this and just rotate the
            % whole system
            rotation_angle = mod(atan2(obj.normal(2), obj.normal(1)), 2 * pi);
            rotation_transform = [
                cos(rotation_angle), -sin(rotation_angle); ...
                sin(rotation_angle), cos(rotation_angle) ...
            ];

            ray_prime = rotation_transform * ray';
            intersection_prime = rotation_transform * intersection';
            midpoint_prime = rotation_transform * (obj.start' + obj.stop') / 2;
            
            % now we compute everything in our rotated coordinate system
            % determine relative position to normal and midpoint
            focal_direction = sign(dot(ray, obj.normal));
            intersection_direction = sign(intersection_prime(2) - midpoint_prime(2));
            shift_sign = - focal_direction * intersection_direction;
            shift_angle = abs(atan((intersection_prime(2) - midpoint_prime(2)) / obj.focal_length)); 
            shift_rotation = [
                cos(shift_sign * shift_angle), -sin(shift_sign * shift_angle); ...
                sin(shift_sign * shift_angle), cos(shift_sign * shift_angle) ...
            ];

            % now we compute our new ray and intersect
            ray = transpose(rotation_transform' * shift_rotation * ray_prime);            
            ray_origin = intersection + obj.normal * focal_direction * 0.0001;
        end 
    end
end
