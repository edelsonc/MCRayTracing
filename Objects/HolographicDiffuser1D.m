classdef HolographicDiffuser1D < Panel1D
    % Subclass of Panel1D which implements ray diffusion. The class implements
    % diffusion as a random process, picking a random angle ~ N(0, angle ^ 2)
    % and altering the incoming rays path by this perturbation.
    properties
        angle
    end
    methods
        function obj = HolographicDiffuser1D(start, stop, diffusion_angle)
            obj@Panel1D(start, stop);
            obj.angle = diffusion_angle;
        end
        function [ray, ray_origin] = get_propogated_ray(obj, ray, intersection);

            % shift the ray a little to make sure it doesn't intercept with the
            % diffuser
            shift_position = sign(dot(obj.normal, ray)) * 0.0001 * obj.normal;
            ray_origin = intersection + shift_position;

            % new random angle around our current angle
            ray_angle = mod(atan2(ray(2),  ray(1)), 2 * pi); 
            % new_angle = normrnd(ray_angle, obj.angle);
            new_angle = ray_angle + obj.angle * randn();

            ray = [cos(new_angle), sin(new_angle)];
            ray = ray ./ norm(ray);
        end
    end
end
