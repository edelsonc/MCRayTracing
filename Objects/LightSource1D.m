classdef LightSource1D < handle
    properties
        position
        ray_angles
    end
    methods
        function obj = LightSource1D(position, ray_angles)
            angle_condition =0 <= ray_angles(1) & ray_angles(1) < ray_angles(2) & ray_angles(2) <= 2 * pi;
            ast_msg = "`ray_angles` must satisfy 0 <= ray_angles(1) <= ray_angles(2) <= 2 * pi";
            assert(angle_condition, ast_msg)

            obj.position = position;
            obj.ray_angles = ray_angles;
        end
        function [ray, ray_origin] = get_ray(obj)
            angle = (obj.ray_angles(2) - obj.ray_angles(1)) * rand() + obj.ray_angles(1);
            ray = [cos(angle), sin(angle)];
            ray = ray ./ norm(ray);
            ray_origin = obj.position;
        end
    end
end
